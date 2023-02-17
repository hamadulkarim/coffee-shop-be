describe 'POST /api/v1/line_items', { type: :request, skip_request: true } do
  let(:user) { create(:user) }
  let!(:food) { create(:food, name: 'Cupcake', price: 7.7, tax_rate: 9.9) }
  let(:params) { { quantity: 3, food_id: food.hashid } }
  let!(:request!) { post api_v1_line_items_path, params: params, headers: headers, as: :json }

  context 'with user not signed in' do
    include_examples 'have http status', :unauthorized

    it do
      expect(json[:errors]).to include('Authentication is required to perform this action')
    end
  end

  context 'with customer user signed in' do
    let(:headers) { auth_headers }
    let(:created_line_item) { LineItem.last }

    context 'with valid params' do
      include_examples 'have http status', :ok

      it 'renders show template' do
        expect(response).to render_template('show')
      end

      it 'checks instance variable' do
        expect(assigns(:line_item)).to eq(created_line_item)
      end

      it 'checks data returned' do
        expect(json[:body][:line_item]).to include(
          {
            id: created_line_item.hashid,
            quantity: 3,
            food: 'Cupcake',
            total_price: 25.386
          }
        )
      end
    end

    context 'with invalid params' do
      let!(:params) { { quantity: 0, food_id: food.id } }

      include_examples 'have http status', :unprocessable_entity
    end
  end

  context 'with shopkeeper signed in, it returns 401' do
    let(:shopkeeper) { create(:user, role: 'shopkeeper') }
    let(:headers) { shopkeeper_auth_headers }

    include_examples 'have http status', :unauthorized
  end
end
