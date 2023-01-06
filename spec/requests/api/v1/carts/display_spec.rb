describe 'GET /api/v1/current_cart', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }
  let!(:request!) { get api_v1_display_current_cart_path, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    specify 'renders display template' do
      expect(response).to render_template('display')
    end

    specify 'checks instance variable' do
      expect(assigns(:current_cart)).to eq(cart)
    end

    specify 'checks data returned' do
      expect(json[:body][:current_cart]).to include(
        {
          user: user.first_name,
          total_prep_time: cart.total_prep_time,
          total_bill: cart.total_bill,
          total_discount: cart.total_discount,
          items: []
        }
      )
    end
  end
end
