describe 'GET /api/v1/orders', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let!(:order) { create(:order, user: user) }
  let!(:line_item) { order.line_items.first }
  let!(:request!) { get api_v1_orders_path, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    specify 'renders index template' do
      expect(response).to render_template('index')
    end

    specify 'checks instance variable' do
      expect(assigns(:orders)).to match_array([order])
    end

    specify 'checks data returned' do
      expect(json[:body][:orders]).to include(
        {
          id: order.hashid,
          status: order.status,
          total_prep_time: order.total_prep_time,
          sub_total: order.sub_total,
          total_discount: order.total_discount,
          total_bill: order.total_bill,
          items: [
            id: line_item.hashid,
            quantity: line_item.quantity,
            order: line_item.order_id,
            food: line_item.food.name,
            total_price: line_item.total_price.round(3)
          ]
        }
      )
    end
  end
end
