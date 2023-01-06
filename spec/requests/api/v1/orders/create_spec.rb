describe 'POST /api/v1/orders', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let(:food) { create(:food) }
  let(:cart) { create(:cart, :with_item, user: user) }
  let!(:line_item) { cart.line_items.first }
  let!(:request!) { post api_v1_orders_path, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }
    let(:created_order) { Order.last }

    # resolve
    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:order)).to eq(created_order)
    end

    # resolve
    specify 'checks data returned' do
      expect(json[:body][:order]).to include(
        {
          id: created_order.hashid,
          status: created_order.status,
          total_prep_time: cart.total_prep_time,
          sub_total: created_order.sub_total,
          total_bill: cart.total_bill,
          total_discount: cart.total_discount,
          items: [
            {
              quantity: line_item.quantity,
              order: created_order.hashid,
              food: food.name,
              total_price: line_item.total_price.round(3)
            }
          ]
        }
      )
    end
  end
end
