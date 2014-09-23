require 'csv'
class MassLine < ActiveRecord::Base
  acts_as_paranoid

  after_initialize :assign_static_values

  before_validation :set_ink_volume, :downcase_prefix
  validate :prefix, :no_prefix_conflict

  validates :prefix, :file_location_prefix, :machine_mode, :platen, :resolution, :ink, :ink_volume,
            :highlight3, :mask3, :highlightp, :maskp, :tolerance,
            :choke_width, :width, :height, :from_top, :from_center,
            presence: true

  default_scope order(:prefix)

  def self.generate_from_csv(csv)
    error_prefixes = []
    CSV.foreach(csv, headers: true) do |row|
      ml = MassLine.find_or_initialize_by(prefix: row['PREFIX'], platen: row['PLATEN'])
      ml.attributes.each do |attr, val|
        if !row[attr.upcase].nil?
          ml.attributes = { attr => row[attr.upcase] }
        end
      end

      if !ml.prefix.nil?
        ml.prefix.downcase!
        if !ml.save
          error_prefixes << row['PREFIX']
        end
      end
    end
    error_prefixes
  end

  private

  def downcase_prefix
    self.prefix.downcase!
  end

  def no_prefix_conflict
    MassLine.all.each do |mass_line|
      if (mass_line.prefix.starts_with? self.prefix or self.prefix.starts_with? mass_line.prefix) and mass_line.platen == self.platen and self.id != mass_line.id
        errors.add(:prefix, "There's a sku conflict with the mass line #{mass_line.prefix}")
      end
    end
  end

  def set_ink_volume
    if self.ink == 'C'
      self.ink_volume = 10
    else
      self.ink_volume = 0
    end
  end


  def assign_static_values
    self.machine_mode = 'GT-381'
    self.print_with_black_ink = true unless !self.print_with_black_ink.blank?
    self.resolution = 600 unless !self.resolution.blank?
    self.white_color_pause = false unless !self.white_color_pause.blank?
    self.unidirectional = false unless !self.unidirectional.blank?
    self.multiple_pass = false unless !self.multiple_pass.blank?
  end

end
