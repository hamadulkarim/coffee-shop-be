# Creating Shopkeeper Account
Rails.logger.debug 'Creating Shopkeeper User......'
FactoryBot.create(:user, email: 'admin@coffee.com', role: 'shopkeeper')

# Creating 5 Customer Accounts
Rails.logger.debug 'Creating Customer Users......'
FactoryBot.create_list(:user, 5)

# Creating different types of Food w.r.t their status and category
Rails.logger.debug 'Creating Foods......'
FactoryBot.create_list(:food, 5, :complementary, :out_of_stock)
FactoryBot.create_list(:food, 5, :complementary, :available)
FactoryBot.create_list(:food, 5, :paid, :out_of_stock)
FactoryBot.create_list(:food, 5, :paid, :available)

# Creating Discounts
Rails.logger.debug 'Creating Discounts......'
FactoryBot.create_list(:discount, 3)

# Creating Orders
Rails.logger.debug 'Creating Orders......'
FactoryBot.create_list(:order, 2)
