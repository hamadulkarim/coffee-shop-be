describe 'POST /api/v1/line_items', { type: :request, skip_request: true } do
  let(:request) { post api_v1_line_items_path, params: params, headers: headers, as: :json }
  let(:user) { create(:user) }
  let(:food) { create(:food) }
  let(:params) { { quantity: 3, food_id: food.id } }

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
    let(:created_line_item) { LineItem.last }

    it 'returns a successful response with create template' do
      request

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('create')
      expect(assigns(:line_item)).to eq(created_line_item)
      expect(json).to include(
        {
          quantity: created_line_item.quantity,
          order: created_line_item.order_id,
          food: created_line_item.food.name,
          total_price: created_line_item.total_price
        }
      )
    end
  end
end
