describe 'PATCH /api/v1/current_cart/empty', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let!(:cart) { create(:cart, :with_item, user: user) }
  let!(:request!) { patch api_v1_empty_current_cart_path, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    it 'renders show template' do
      expect(response).to render_template('show')
    end

    it 'checks instance variable' do
      expect(assigns(:current_cart)).to eq(cart)
    end

    it 'checks data returned' do
      expect(json[:body][:current_cart]).to include(
        {
          id: cart.hashid,
          total_prep_time: 0,
          sub_total: 0,
          total_discount: 0,
          total_bill: 0,
          items: []
        }
      )
    end
  end

  context 'with shopkeeper signed in, it returns 401' do
    let(:shopkeeper) { create(:user, role: 'shopkeeper') }
    let(:headers) { shopkeeper_auth_headers }

    include_examples 'have http status', :unauthorized
  end
end
