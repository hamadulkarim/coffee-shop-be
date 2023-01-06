describe 'GET /api/v1/shopkeeper/discounts', { type: :request, skip_request: true } do
  let(:user) { create(:user, role: 'shopkeeper') }
  let!(:discount) { create(:discount) }
  let!(:request!) { get api_v1_shopkeeper_discounts_path, headers: headers, as: :json }

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    specify 'renders index template' do
      expect(response).to render_template('index')
    end

    specify 'checks instance variable' do
      expect(assigns(:discounts)).to eq([discount])
    end

    specify 'checks data returned' do
      expect(json[:body][:discounts]).to include(
        {
          id: discount.hashid,
          discount_on: discount.discounted_food.name,
          in_combination: discount.combination_food.name,
          discount_rate: discount.discount_rate,
          amount_discounted: discount.amount_discounted
        }
      )
    end
  end
end
