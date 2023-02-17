describe 'GET /api/v1/discounts/:id', { type: :request, skip_request: true } do
  let(:discounted_food)  { create(:food, name: 'Cupcake', price: 7.7) }
  let(:combination_food) { create(:food, name: 'Tea') }
  let!(:discount) do
    create(:discount, discounted_food: discounted_food, combination_food: combination_food,
                      discount_rate: 25)
  end
  let!(:request!) { get api_v1_discount_path(discount), as: :json }

  context 'when sending request' do
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
end
