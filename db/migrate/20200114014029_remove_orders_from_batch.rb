class RemoveOrdersFromBatch < ActiveRecord::Migration[5.2]
  def change
    remove_column :batches, :orders, :string
  end
end
