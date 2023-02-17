describe 'GET /api/v1/foods', { type: :request, skip_request: true } do
  let!(:foods) { create_list(:food, 3) }
  let!(:request!) { get api_v1_foods_path, as: :json }

  context 'when sending request' do
    include_examples 'have http status', :ok

    it 'renders index template' do
      expect(response).to render_template('index')
    end

    it 'checks instance variable' do
      expect(assigns(:foods)).to include(foods.last)
    end

    it 'checks data returned' do
      expect(json[:body][:foods]).not_to be_empty
    end

    it 'checks meta data related to pagination' do
      expect(json[:meta]).to include(
        {
          displayed_items: 3,
          total_items: 3,
          current_page: 1,
          total_pages: 1
        }
      )
    end
  end
end
