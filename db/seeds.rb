# This is not the place for test data
# Only use this to put the necessary setup for the app to work
# Separate the seeds in different Seed Service Objects
# The data can then be loaded with the rails db:seed command

FactoryBot.create(:user)

5.times do
  FactoryBot.create(:food, :complementary, :out_of_stock)
  FactoryBot.create(:food, :complementary, :available)
  FactoryBot.create(:food, :paid, :out_of_stock)
  FactoryBot.create(:food, :complementary, :available)
end
