require 'csv'

class Spreadsheet < ActiveRecord::Base
  before_create :initialize_state


  has_attached_file :file

  validates_attachment :file,
                 content_type: {
                     content_type: %w(application/vnd.ms-excel text/csv text/plain),
                     message: 'must be in CSV Format'
                 }

  validates :batch_id, presence: true, numericality: true
  validates :file, presence: true


  def create_arps
    CSV.foreach(self.file.path, headers: true) do |row|
      Arp.find_or_create_by(sku: row['SKU'].strip, platen: row['PLATEN'].strip)
    end
  end

  private

  def initialize_state
    self.state = 'Pending'
  end

end
