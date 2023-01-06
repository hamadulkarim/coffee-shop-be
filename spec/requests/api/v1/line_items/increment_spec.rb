describe 'PATCH /api/v1/line_items/:id/add', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let!(:line_item) { create(:line_item, cart: cart) }
  let!(:request!) { patch api_v1_line_item_add_path(line_item), headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    specify do
      expect(JSON.parse(response.body)['errors']).to include('Authentication is required to perform this action')
    end
  end

  context 'with user signed in' do
    let(:headers) { auth_headers }

    include_examples 'have http status', :ok

    specify 'renders show template' do
      expect(response).to render_template('show')
    end

    specify 'checks instance variable' do
      expect(assigns(:line_item)).to eq(line_item)
    end

    specify 'checks data returned' do
      expect(assigns(:line_item)).to eq(line_item)
    end

    specify 'checks data returned' do
      expect(json[:body][:line_item]).to include(
        {
          quantity: line_item.quantity + 1,
          order: line_item.order_id,
          food: line_item.food.name,
          total_price: ((line_item.total_price / line_item.quantity) * (line_item.quantity + 1)).round(3)
        }
      )
    end
  end
end
