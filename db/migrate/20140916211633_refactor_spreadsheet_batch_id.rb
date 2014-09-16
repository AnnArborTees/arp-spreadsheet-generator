class RefactorSpreadsheetBatchId < ActiveRecord::Migration
  def change
    change_column :spreadsheets, :batch_id, :string
  end
end
