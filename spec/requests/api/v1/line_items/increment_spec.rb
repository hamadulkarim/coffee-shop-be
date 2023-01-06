describe 'PATCH /api/v1/line_items/:id/add', { type: :request, skip_request: true } do
  let(:request) { patch api_v1_line_item_add_path(line_item), headers: headers, as: :json }
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let!(:line_item) { create(:line_item, cart: cart) }

  context 'with user not signed in' do
    it 'does not render increment template' do
      request

      expect(response.status).to eq(401)
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    it 'returns a successful response with increment template' do
      request

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('increment')
      expect(assigns(:line_item)).to eq(line_item)
      expect(json).to include(
        {
          quantity: line_item.quantity + 1,
          order: line_item.order_id,
          food: line_item.food.name,
          total_price: (line_item.total_price / line_item.quantity) * (line_item.quantity + 1)
        }
      )
    end
  end
end
