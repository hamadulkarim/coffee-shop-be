describe 'DELETE /api/v1/carts/:id', { type: :request, skip_request: true } do
  let(:request) { delete api_v1_cart_path(cart), headers: headers, as: :json }
  let(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }

  context 'with user not signed in' do
    it 'does not render delete template' do
      request

      expect(response.status).to eq(401)
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    it 'returns a successful response with delete template' do
      request

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('destroy')
      expect(assigns(:cart)).to eq(cart)
      expect(json).to include(
        {
          msg: 'Successfully emptied cart!'
        }
      )
    end
  end
end
