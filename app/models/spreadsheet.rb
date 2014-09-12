require 'csv'

class Spreadsheet < ActiveRecord::Base
  before_create :initialize_state
  after_save :create_arps


  has_attached_file :file
  has_many :arps

  validates_attachment :file,
                 content_type: {
                     content_type: %w(application/vnd.ms-excel text/csv text/plain),
                     message: 'must be in CSV Format'
                 }

  validates :batch_id, presence: true, numericality: true
  validates :file, presence: true


  def create_arps
    CSV.foreach(file.queued_for_write[:original].path, headers: true) do |row|
      Arp.find_or_create_by(sku: row['SKU'].strip, platen: row['PLATEN'].strip, spreadsheet_id: self.id)
    end
  end



  private

  def initialize_state
    self.state = 'Pending'
  end

end
