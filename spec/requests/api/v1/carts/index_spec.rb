describe 'GET /api/v1/carts', { type: :request, skip_request: true } do
  let(:request) { get api_v1_carts_path, headers: headers, as: :json }
  let(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }

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
      expect(assigns(:cart)).to eq(cart)
      expect(json).to include(
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
