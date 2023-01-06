describe 'POST /api/v1/line_items', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let!(:food) { create(:food) }
  let!(:params) { { quantity: 3, food_id: food.id } }
  let!(:request!) { post api_v1_line_items_path, params: params, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }
    let(:created_line_item) { LineItem.last }

    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:line_item)).to eq(created_line_item)
    end

    specify 'checks data returned' do
      expect(json[:body][:line_item]).to include(
        {
          quantity: created_line_item.quantity,
          order: created_line_item.order_id,
          food: created_line_item.food.name,
          total_price: created_line_item.total_price.round(3)
        }
      )
    end
  end
end
