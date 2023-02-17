describe 'DELETE /api/v1/shopkeeper/discounts/:id', { type: :request, skip_request: true } do
  let(:shopkeeper) { create(:user, role: 'shopkeeper') }
  let!(:discount) { create(:discount) }
  let!(:request!) { delete api_v1_shopkeeper_discount_path(discount), headers: headers, as: :json }

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { shopkeeper_auth_headers }

    include_examples 'have http status', :no_content

    it 'checks instance variable' do
      expect(assigns(:discount)).to eq(discount)
    end

    it 'checks data returned' do
      expect(response.body).to eq('')
    end
  end

  context 'with customer user signed in' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers }

    include_examples 'have http status', :unauthorized
  end
end
