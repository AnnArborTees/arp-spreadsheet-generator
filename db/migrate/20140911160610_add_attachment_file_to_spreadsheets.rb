class AddAttachmentFileToSpreadsheets < ActiveRecord::Migration
  def self.up
    change_table :spreadsheets do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :spreadsheets, :file
  end
end
