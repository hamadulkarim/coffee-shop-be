describe 'POST /api/v1/orders', { type: :request, skip_request: true } do
  let(:cart) { create(:cart, user: user) }
  let(:food) { create(:food, name: 'Pizza', prep_mins: 5, price: 5.5, tax_rate: 11) }
  let!(:line_item) { create(:line_item, quantity: 2, food: food, cart: cart) }

  let!(:user) { create(:user) }
  let!(:request!) { post api_v1_orders_path, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }
    let(:created_order) { Order.last }

    it 'renders show template' do
      expect(response).to render_template('show')
    end

    it 'checks instance variable' do
      expect(assigns(:order)).to eq(created_order)
    end

    it 'checks data returned' do
      expect(json[:body][:order]).to include(
        {
          id: created_order.hashid,
          status: 'preparing',
          total_prep_time: 10,
          sub_total: 12.21,
          total_bill: 12.21,
          total_discount: 0,
          items: [
            {
              id: line_item.hashid,
              quantity: 2,
              food: 'Pizza',
              total_price: 12.21
            }
          ]
        }
      )
    end
  end
end
