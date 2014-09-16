class SpreadsheetArp < ActiveRecord::Base
  belongs_to :spreadsheet
  belongs_to :arp

  validates :spreadsheet, :arp, presence: true

end
