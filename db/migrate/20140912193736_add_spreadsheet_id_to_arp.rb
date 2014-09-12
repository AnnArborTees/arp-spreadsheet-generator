class AddSpreadsheetIdToArp < ActiveRecord::Migration
  def change
    add_column :arps, :spreadsheet_id, :integer
    add_index :arps, :spreadsheet_id
  end
end
