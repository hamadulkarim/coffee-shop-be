describe 'GET /api/v1/orders/:id', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let!(:order) { create(:order, user: user) }
  let!(:line_item) { order.line_items.first }
  let!(:request!) { get api_v1_order_path(order), headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    it 'renders show template' do
      expect(response).to render_template('show')
    end

    it 'checks instance variable' do
      expect(assigns(:order)).to eq(order)
    end

    it 'checks data returned' do
      expect(json[:body][:order]).to include(
        {
          id: order.hashid,
          status: order.status,
          total_prep_time: order.total_prep_time,
          sub_total: order.sub_total,
          total_discount: order.total_discount,
          total_bill: order.total_bill,
          items: [
            {
              id: line_item.hashid,
              quantity: line_item.quantity,
              food: line_item.food.name,
              total_price: line_item.total_price.round(3)
            }
          ]
        }
      )
    end
  end
end
