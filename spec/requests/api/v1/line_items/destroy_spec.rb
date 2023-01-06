describe 'DELETE /api/v1/line_items/:id', { type: :request, skip_request: true } do
  let(:request) { delete api_v1_line_item_path(line_item), headers: headers, as: :json }
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let!(:line_item) { create(:line_item, cart: cart) }

  context 'with user not signed in' do
    it 'does not render destroy template' do
      request

      expect(response.status).to eq(401)
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    it 'returns a successful response with destroy template' do
      request

      expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('destroy')
      expect(assigns(:line_item)).to eq(line_item)
      expect(json).to include(
        {
          msg: 'Destroyed Line Item'
        }
      )
    end
  end
end
