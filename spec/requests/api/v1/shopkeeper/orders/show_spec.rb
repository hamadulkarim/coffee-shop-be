describe 'GET /api/v1/shopkeeper/orders/:id', { type: :request, skip_request: true } do
  let(:user) { create(:user, role: 'shopkeeper') }
  let!(:order) { create(:order) }
  let!(:line_item) { order.line_items.first }

  let!(:request!) { get api_v1_shopkeeper_order_path(order), headers: headers, as: :json }

  context 'with shopkeeper not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with shopkeeper signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:order)).to eq(order)
    end

    specify 'checks data returned' do
      expect(json[:body][:order]).to include(
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
