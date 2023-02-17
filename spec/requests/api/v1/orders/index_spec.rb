describe 'GET /api/v1/orders', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let!(:orders) { create_list(:order, 3, user: user) }
  let!(:request!) { get api_v1_orders_path, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    it 'renders index template' do
      expect(response).to render_template('index')
    end

    it 'checks instance variable' do
      expect(assigns(:orders)).to include(orders.last)
    end

    it 'checks data returned' do
      expect(json[:body][:orders]).not_to be_empty
    end

    it 'checks meta data related to pagination' do
      expect(json[:meta]).to include(
        {
          displayed_items: 3,
          total_items: 3,
          current_page: 1,
          total_pages: 1
        }
      )
    end
  end
end
