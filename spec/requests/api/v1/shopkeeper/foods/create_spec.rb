describe 'POST /api/v1/shopkeeper/foods', { type: :request, skip_request: true } do
  let(:shopkeeper) { create(:user, role: 'shopkeeper') }

  let!(:params) do
    {
      name: 'Cupcake',
      description: 'Sweet treat',
      price: 7.7,
      tax_rate: 9.9,
      status: 'available',

      prep_mins: 13,
      category: 'paid'

    }
  end

  let!(:request!) { post api_v1_shopkeeper_foods_path, headers: headers, params: params, as: :json }

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { shopkeeper_auth_headers }
    let(:created_food) { Food.last }

    context 'with valid params' do
      include_examples 'have http status', :ok

      it 'renders show template' do
        expect(response).to render_template('show')
      end

      it 'checks instance variable' do
        expect(assigns(:food)).to eq(created_food)
      end

      it 'checks data returned' do
        expect(json[:body][:food]).to include(
          {
            id: created_food.hashid,
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

    context 'with invalid params, it returns 422' do
      let!(:params) { { name: nil } }

      include_examples 'have http status', :unprocessable_entity
    end
  end

  context 'with customer user signed in' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers }

    include_examples 'have http status', :unauthorized
  end
end
