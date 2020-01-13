class AddBatchRefsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :batch, foreign_key: true
  end
end
