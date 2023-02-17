describe 'GET /api/v1/shopkeeper/foods/:id', { type: :request, skip_request: true } do
  let(:shopkeeper) { create(:user, role: 'shopkeeper') }
  let!(:food) do
    create(
      :food,
      name: 'Cupcake',
      description: 'Sweet treat',
      price: 7.7,
      tax_rate: 9.9,
      prep_mins: 13
    )
  end
  let!(:request!) { get api_v1_shopkeeper_food_path(food), headers: headers, as: :json }

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { shopkeeper_auth_headers }

    include_examples 'have http status', :ok

    it 'renders show template' do
      expect(response).to render_template('show')
    end

    it 'checks instance variable' do
      expect(assigns(:food)).to eq(food)
    end

    it 'checks data returned' do
      expect(json[:body][:food]).to include(
        {
          id: food.hashid,
          name: 'Cupcake',
          description: 'Sweet treat',
          price: 7.7,
          tax_rate: 9.9,
          taxed_price: 8.462,
          status: 'available',
          prep_mins: 13,
          category: 'paid'
        }
      )
    end
  end

  context 'with customer user signed in' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers }

    include_examples 'have http status', :unauthorized
  end
end
