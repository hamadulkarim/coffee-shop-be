describe 'GET /api/v1/shopkeeper/foods/:id', { type: :request, skip_request: true } do
  let(:user) { create(:user, role: 'shopkeeper') }
  let!(:food) { create(:food) }
  let!(:request!) { get api_v1_shopkeeper_food_path(food), headers: headers, as: :json }

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:food)).to eq(food)
    end

    specify 'checks data returned' do
      expect(json[:body][:food]).to include(
        {
          id: food.hashid,
          name: food.name,
          description: food.description,
          price: food.price,
          tax_rate: food.tax_rate,
          taxed_price: food.taxed_price,
          status: food.status,
          prep_mins: food.prep_mins,
          category: food.category
        }
      )
    end
  end
end
