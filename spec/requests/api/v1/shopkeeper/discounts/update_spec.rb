describe 'PATCH /api/v1/shopkeeper/discounts/:id', { type: :request, skip_request: true } do
  let(:shopkeeper) { create(:user, role: 'shopkeeper') }
  let!(:discount) { create(:discount) }
  let(:discounted_food)  { create(:food, name: 'Cupcake', price: 7.7) }
  let(:combination_food) { create(:food, name: 'Tea') }
  let(:params) do
    {
      combination_food_id: combination_food.hashid,
      discounted_food_id: discounted_food.hashid,
      discount_rate: 25
    }
  end

  let!(:request!) do
    patch api_v1_shopkeeper_discount_path(discount), headers: headers, params: params, as: :json
  end

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { shopkeeper_auth_headers }
    let(:updated_discount) { Discount.last }

    context 'with valid params' do
      include_examples 'have http status', :ok

      it 'renders show template' do
        expect(response).to render_template('show')
      end

      it 'checks instance variable' do
        expect(assigns(:discount)).to eq(updated_discount)
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

    context 'with invalid params, it returns 422' do
      let!(:params) { { discount_rate: 0 } }

      include_examples 'have http status', :unprocessable_entity
    end
  end

  context 'with customer user signed in' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers }

    include_examples 'have http status', :unauthorized
  end
end
