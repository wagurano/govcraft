class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:read]
  def read
    order = Order.find_by(comment_id: params[:Metadata][:comment_id], agent_id: params[:Metadata][:agent_id])
    return if order.blank?
    order.touch :read_at
  end
end
