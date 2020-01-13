class CreateBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :batches do |t|
      t.string :reference
      t.string :purchase_channel
      t.string :orders

      t.timestamps
    end
  end
end
