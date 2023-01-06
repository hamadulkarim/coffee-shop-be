describe 'GET /api/v1/discounts/:id', { type: :request, skip_request: true } do
  let!(:discount) { create(:discount) }
  let!(:request!) { get api_v1_discount_path(discount), as: :json }

  include_examples 'have http status', :ok

  specify 'renders show template' do
    expect(response).to render_template('show')
  end

  specify 'checks instance variable' do
    expect(assigns(:discount)).to eq(discount)
  end

  specify 'checks data returned' do
    expect(json[:body][:discount]).to include(
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
