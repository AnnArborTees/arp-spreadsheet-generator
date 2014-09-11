class Arp < ActiveRecord::Base

  after_initialize :assign_static_values
  before_save :assign_complete

  validates :sku, uniqueness: {scope: :platen}, presence: true
  validates :platen, presence: true


  private

  def assign_static_values
    self.machine_mode = 'GT-381'
    self.resolution = 600
    self.tolerance = 30
    self.choke_width = 3
    self.white_color_pause = 0
    self.unidirectional = 0
  end

  def assign_complete
    self.complete = true
    self.attributes.each do |attr, val|
      if attr != 'complete'
        if val.blank?
          self.complete = false
        end
      end
    end
  end

end
