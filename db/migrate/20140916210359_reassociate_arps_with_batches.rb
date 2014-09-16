class ReassociateArpsWithBatches < ActiveRecord::Migration
  def change
    Arp.all.each do |arp|
      ss = Spreadsheet.find(arp.spreadsheet_id)
      arp.spreadsheets << ss
      arp.save
    end
  end
end
