describe 'POST /api/v1/orders', { type: :request, skip_request: true } do
  let(:request) { post api_v1_orders_path, params: params, headers: headers, as: :json }
  let(:user) { create(:user) }
  let(:food) { create(:food) }
  let(:cart) { create(:cart, user: user) }
  let!(:line_item) { create(:line_item, food_id: food.id, cart: cart) }
  let(:params) { { status: 'pending' } }

  context 'with user not signed in' do
    it 'does not render create template' do
      request

      expect(response.status).to eq(401)
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }
    let(:created_order) { Order.last }

    it 'returns a successful response with create template' do
      request

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('create')
      expect(assigns(:order)).to eq(created_order)
      expect(json).to include(
        {
          status: created_order.status,
          total_prep_time: cart.total_prep_time,
          total_bill: cart.total_bill,
          total_discount: cart.total_discount,
          items: [
            {
              quantity: line_item.quantity,
              order: created_order.id,
              food: food.name,
              total_price: line_item.total_price
            }
          ]
        }
      )
    end
  end
end
