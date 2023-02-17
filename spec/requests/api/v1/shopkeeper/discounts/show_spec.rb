describe 'GET /api/v1/shopkeeper/discounts/:id', { type: :request, skip_request: true } do
  let(:shopkeeper) { create(:user, role: 'shopkeeper') }
  let(:discounted_food)  { create(:food, name: 'Cupcake', price: 7.7) }
  let(:combination_food) { create(:food, name: 'Tea') }
  let!(:discount) do
    create(:discount, discounted_food: discounted_food, combination_food: combination_food,
                      discount_rate: 25)
  end
  let!(:request!) { get api_v1_shopkeeper_discount_path(discount), headers: headers, as: :json }

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
      expect(assigns(:discount)).to eq(discount)
    end

    it 'checks data returned' do
      expect(json[:body][:discount]).to include(
        {
          id: discount.hashid,
          discount_on: 'Cupcake',
          in_combination: 'Tea',
          discount_rate: 25,
          amount_discounted: 1.925
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
