class CreateSpreadsheetArps < ActiveRecord::Migration
  def change
    create_table :spreadsheet_arps do |t|
      t.references :spreadsheet
      t.references :arp
    end

    add_index :spreadsheet_arps, :spreadsheet_id
    add_index :spreadsheet_arps, :arp_id
  end
end
