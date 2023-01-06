describe 'GET /api/v1/orders/:id', { type: :request, skip_request: true } do
  let(:request) { get api_v1_order_path(order), headers: headers, as: :json }
  let(:user) { create(:user) }
  let(:food) { create(:food) }
  let(:order) { create(:order, user: user) }
  let!(:line_item) { create(:line_item, :for_order, order: order, food: food) }

  context 'with user not signed in' do
    it 'does not render show template' do
      request

      expect(response.status).to eq(401)
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    it 'returns a successful response with show template' do
      request

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('show')
      expect(assigns(:order)).to eq(order)
      expect(json).to include(
        {
          status: order.status,
          total_prep_time: order.total_prep_time,
          total_bill: order.total_bill,
          total_discount: order.total_discount,
          items: [
            {
              quantity: line_item.quantity,
              order: order.id,
              food: food.name,
              total_price: line_item.total_price
            }
          ]
        }
      )
    end
  end
end
