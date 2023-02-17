describe 'PATCH /api/v1/line_items/:id/increase', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let(:food) { create(:food, name: 'Cupcake', price: 7.7, tax_rate: 9.9) }
  let(:cart) { create(:cart, user: user) }
  let!(:line_item) { create(:line_item, food: food, cart: cart, quantity: 3) }
  let!(:request!) { patch api_v1_line_item_increase_path(line_item), headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with customer user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    it 'renders show template' do
      expect(response).to render_template('show')
    end

    it 'checks instance variable' do
      expect(assigns(:line_item)).to eq(line_item)
    end

    it 'checks data returned' do
      expect(assigns(:line_item)).to eq(line_item)
    end

    it 'checks data returned' do
      expect(json[:body][:line_item]).to include(
        {
          id: line_item.hashid,
          quantity: 4,
          food: 'Cupcake',
          total_price: 33.848
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
