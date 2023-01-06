describe 'PATCH /api/v1/shopkeeper/foods/:id', { type: :request, skip_request: true } do
  let(:user) { create(:user, role: 'shopkeeper') }
  let!(:food) { create(:food) }
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

  let!(:request!) do
    patch api_v1_shopkeeper_food_path(food), headers: headers, params: params, as: :json
  end

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { auth_headers }
    let(:updated_food) { Food.last }

    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:food)).to eq(updated_food)
    end

    specify 'checks data returned' do
      expect(json[:body][:food]).to include(
        {
          id: updated_food.hashid,
          name: updated_food.name,
          description: updated_food.description,
          price: updated_food.price,
          tax_rate: updated_food.tax_rate,
          taxed_price: updated_food.taxed_price,
          status: updated_food.status,
          prep_mins: updated_food.prep_mins,
          category: updated_food.category
        }
      )
    end
  end
end
