describe 'GET /api/v1/user', { type: :request } do
  let(:request!) { get api_v1_user_path, headers: headers, as: :json }
  let(:user) { create(:user) }

  context 'when being signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    it do
      expect(json[:body][:user]).to include_json(
        id: user.hashid,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email
      )
    end
  end

  context 'when not being signed in' do
    it_behaves_like 'an authenticated endpoint'
  end
end
