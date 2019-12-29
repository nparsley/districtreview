class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.text :message
      t.timestamps
    end
  end
end
