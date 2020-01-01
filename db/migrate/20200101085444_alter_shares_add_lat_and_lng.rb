class AlterSharesAddLatAndLng < ActiveRecord::Migration[5.2]
  def change
    add_column :shares, :latitude, :float
    add_column :shares, :longitude, :float
  end
end
