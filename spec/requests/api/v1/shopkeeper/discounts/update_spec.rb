describe 'PATCH /api/v1/shopkeeper/discounts/:id', { type: :request, skip_request: true } do
  let(:user) { create(:user, role: 'shopkeeper') }
  let!(:discounted_food) { create(:food) }
  let!(:combination_food) { create(:food) }
  let!(:discount) { create(:discount) }
  let!(:params) do
    { discounted_food_id: discounted_food.id, combination_food_id: combination_food.id,
      discount_rate: 10 }
  end

  let!(:request!) do
    patch api_v1_shopkeeper_discount_path(discount), headers: headers, params: params, as: :json
  end

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { auth_headers }
    let(:updated_discount) { Discount.last }

    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:discount)).to eq(updated_discount)
    end

    specify 'checks data returned' do
      expect(json[:body][:discount]).to include(
        {
          id: updated_discount.hashid,
          discount_on: updated_discount.discounted_food.name,
          in_combination: updated_discount.combination_food.name,
          discount_rate: updated_discount.discount_rate,
          amount_discounted: updated_discount.amount_discounted
        }
      )
    end
  end
end
