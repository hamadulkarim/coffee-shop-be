describe 'GET /api/v1/discounts', { type: :request, skip_request: true } do
  let!(:discount) { create(:discount) }
  let!(:request!) { get api_v1_discounts_path, as: :json }

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
