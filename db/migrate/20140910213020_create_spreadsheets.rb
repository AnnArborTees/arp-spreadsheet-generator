class CreateSpreadsheets < ActiveRecord::Migration
  def change
    create_table :spreadsheets do |t|
      t.integer :user_id
      t.integer :batch_id

      t.timestamps
    end
  end
end
