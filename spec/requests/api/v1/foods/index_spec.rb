describe 'GET /api/v1/foods', { type: :request, skip_request: true } do
  let!(:foods) { create_list(:food, 2) }
  let!(:request!) { get api_v1_foods_path, as: :json }


  include_examples 'have http status', :ok

  specify 'renders index template' do
    expect(response).to render_template('index')
  end

  specify 'checks instance variable' do
    byebug
    expect(assigns(:foods)).to eq(foods)
  end

  # specify 'checks data returned' do
#     byebug
#     expect(json[:body][:foods]).to include(
#       {  
#         [
#           {
#             id: foods.first.hashid,
#             name: foods.first.name,
#             description: foods.first.description,
#             price: foods.first.price,
#             tax_rate: foods.first.tax_rate,
#             taxed_price: food.first.taxed_price,
#             status: foods.first.status,
#             prep_mins: foods.first.prep_mins,
#             category: foods.first.category
#           },
#          { id: foods.second.hashid,
#           name: foods.second.name,
#           description: foods.second.description,
#           price: foods.second.price,
#           tax_rate: foods.second.tax_rate,
#           taxed_price: food.second.taxed_price,
#           status: foods.second.status,
#           prep_mins: foods.second.prep_mins,
#           category: foods.second.category
#         }

# ] }   )
#   end
end
