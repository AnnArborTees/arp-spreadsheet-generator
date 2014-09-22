require 'csv'
require 'net/ftp'

class Spreadsheet < ActiveRecord::Base
  before_create :initialize_state
  after_save :create_arps

  default_scope order('id DESC')


  has_attached_file :file
  has_many :arps, -> { uniq }, through: :spreadsheet_arps
  has_many :spreadsheet_arps

  validates_attachment :file,
                 content_type: {
                     content_type: %w(application/vnd.ms-excel text/csv text/plain),
                     message: 'must be in CSV Format'
                 }

  validates :batch_id, presence: true
  validates :file, presence: true


  def create_arps
    CSV.foreach(file.queued_for_write[:original].path, headers: true) do |row|
      arps << Arp.find_or_create_by(sku: row['SKU'].strip, platen: row['PLATEN'].strip)
    end
  end

  def csv_download
    columns = Arp.column_names
    columns.delete_if{ |col| %w(created_at updated_at complete spreadsheet_id id).include? col }
    CSV.generate do |csv|
      csv << columns.map{ |x| x.upcase }
      arps.each do |arp|
        if arp.complete?
          csv << arp.attributes.values_at(*columns).map do |i|
            i = format_value(i)
          end
        end
      end
    end
  end

  def arps_to_rename
    arps.where(requires_renaming: true)
  end

  def missing_arps
    arps.where(complete: false)
  end


  def missing_pngs
    ftp = Net::FTP::new(Figaro.env['ftp_host'])
    ftp.login(Figaro.env['ftp_username'], Figaro.env['ftp_password'])
    ftp.passive = Figaro.env['ftp_passive']
    arps_missing_pngs = []
    arps.each do |arp|
      if arp.file_location.blank?
        file = ''
      else
        file = arp.file_location.gsub("\\AATC\\", '').gsub('\\', '/')
      end

      begin
        ftp.size(file)
      rescue Exception => e
        arps_missing_pngs << arp
      end
    end

    return arps_missing_pngs
  end

  private

  def format_value(val)
    if val == true
      return 1
    elsif val == false
      return 0
    else
      return val
    end
  end

  def initialize_state
    self.state = 'Pending'
  end

end
