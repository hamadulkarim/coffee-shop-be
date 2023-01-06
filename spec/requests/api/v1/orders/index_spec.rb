describe 'GET /api/v1/orders', { type: :request, skip_request: true } do
  let(:request) { get api_v1_orders_path, headers: headers, as: :json }
  let(:user) { create(:user) }
  let!(:order) { create(:order, user: user) }

  context 'with user not signed in' do
    it 'does not render index template' do
      request

      expect(response.status).to eq(401)
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    it 'returns a successful response with index template' do
      request

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('index')
      expect(assigns(:orders)).to match_array([order])
      expect(json[:orders]).to include(
        {
          status: order.status,
          total_prep_time: order.total_prep_time,
          total_bill: order.total_bill,
          total_discount: order.total_discount,
          items: []
        }
      )
    end
  end
end
