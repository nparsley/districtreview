class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.integer :share_id
      t.text :caption
      t.integer :user_id
      t.integer :share_id
      t.timestamps
    end

    add_index :photos, [:user_id, :share_id]
    add_index :photos, :share_id
  end
end
