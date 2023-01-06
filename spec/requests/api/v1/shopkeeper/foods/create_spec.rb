describe 'POST /api/v1/shopkeeper/foods', { type: :request, skip_request: true } do
  let(:user) { create(:user, role: 'shopkeeper') }

  let!(:params) do
    {
      name: Faker::Food.dish,
      description: Faker::Food.description,
      price: Faker::Commerce.price(range: 0..50.0),
      tax_rate: Faker::Number.between(from: 1, to: 49),
      status: 'available',
      prep_mins: Faker::Number.between(from: 1, to: 9),
      category: 'paid'
    }
  end

  let!(:request!) { post api_v1_shopkeeper_foods_path, headers: headers, params: params, as: :json }

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { auth_headers }
    let(:created_food) { Food.last }

    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:food)).to eq(created_food)
    end

    specify 'checks data returned' do
      expect(json[:body][:food]).to include(
        {
          id: created_food.hashid,
          name: created_food.name,
          description: created_food.description,
          price: created_food.price,
          tax_rate: created_food.tax_rate,
          taxed_price: created_food.taxed_price,
          status: created_food.status,
          prep_mins: created_food.prep_mins,
          category: created_food.category
        }
      )
    end
  end
end
