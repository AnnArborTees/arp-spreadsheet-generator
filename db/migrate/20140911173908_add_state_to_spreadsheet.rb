class AddStateToSpreadsheet < ActiveRecord::Migration
  def change
    add_column :spreadsheets, :state, :string
    add_index :spreadsheets, :state
  end
end
