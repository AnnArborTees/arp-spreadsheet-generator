class AddDeletedAtToMassLines < ActiveRecord::Migration
  def change
    add_column :mass_lines, :deleted_at, :datetime
    add_index :mass_lines, :deleted_at
  end
end
