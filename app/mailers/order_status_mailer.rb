class OrderStatusMailer < ApplicationMailer
  def send_status
    @user = params[:user]
    @order = params[:order]
    mail(to: @user.email, subject: "Your order has been #{@order.status}")
  end
end
