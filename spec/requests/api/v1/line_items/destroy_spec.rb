describe 'DELETE /api/v1/line_items/:id', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let!(:line_item) { create(:line_item, cart: cart) }
  let!(:request!) { delete api_v1_line_item_path(line_item), headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :no_content

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:line_item)).to eq(line_item)
    end

    specify 'checks data returned' do
      expect(response.body).to eq('')
    end
  end
end
