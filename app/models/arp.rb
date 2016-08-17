require 'open-uri'
require 'net/ftp'

class Arp < ActiveRecord::Base

  PLATENS = %w(14x16 10x12 7x8 16x18)
  INKS = %w(cw C W)
  PLATEN_MOCKBOT_CONVERSIONS = {
    "14x16" => 1,
    "10x12" => 2,
    "7x8" => 3,
    "16x18" => nil

  }
  PRINT_LOCATION_FRONT = 'Front'
  LOCAL_ARTWORK_DIR = "#{Rails.root}/tmp"

  default_scope order(:sku)

  has_many :spreadsheets, through: :spreadsheet_arps
  has_many :spreadsheet_arps
  has_many :customizations
  belongs_to :customizable_line

  after_initialize :assign_static_values
  before_save :downcase_sku

  validates :sku, uniqueness: {scope: :platen}, presence: true, unless: :customizable?
  validates :platen, presence: true
  validates :platen, inclusion: { in: PLATENS }
  # validates :customizations, presence: :true, if: :customizable?
  # validates :customizable_line, presence: :true, if: :customizable?

  accepts_nested_attributes_for :customizations, :reject_if => lambda { |a| a[:spree_variable].blank? || a[:mockbot_variable].blank? || a[:value].blank? },  allow_destroy: true

  def find_mockbot_idea_for_arp
    idea = MockBot::Idea.find(self.sku)
    idea.respond_to?('sku') ? idea : nil
  end

  def populate_info_from_mockbot(idea = nil)
    idea = MockBot::Idea.find(self.sku) unless !idea.nil?
    if idea.respond_to?('sku')
      self.file_location = default_file_location
      if idea.artworks.first.base?
        self.highlight3 = 7
        self.mask3 = 3
        self.highlightp = 1
        self.maskp = 3
        self.ink = 'cw'
        self.ink_volume = 0
        self.pretreat_level = get_max_pretreat_value(idea.colors.map{|c| c.name})
      else
        self.highlight3 = 0
        self.mask3 = 0
        self.highlightp = 0
        self.maskp = 0
        self.ink = 'C'
        self.ink_volume = 10
        self.print_with_black_ink = 1
        self.cmy_gray = 0
        self.pretreat_level = 0
      end

      self.resolution = 600
      self.tolerance = 30
      self.choke_width = 3
      self.white_color_pause = false
      self.unidirectional = false
      self.multiple_pass = false
      self.cmyk_ink_volume = 99.9
      self.white_ink_volume = 99.9


      idea.artworks.each do |artwork|
        platen_size = "#{artwork.imprint_size.width.to_f.floor}x#{artwork.imprint_size.height.to_f.floor}"
        if platen_size == self.platen
          self.from_top = in_inches(artwork.from_top, artwork.dpi)
          self.from_center = in_inches(artwork.from_center, artwork.dpi)
          self.width = in_inches(artwork.width, artwork.dpi)
          self.height = in_inches(artwork.height, artwork.dpi)
          self.transparency = !artwork.is_transparent
          self.print_with_black_ink = true
          self.cmy_gray = false
          if artwork.is_transparent
            self.transparency_red = 0
            self.transparency_blue = 0
            self.transparency_green = 0
          else
            rgb = artwork.background_color.gsub("#", '').scan(/../).map {|color| color.to_i(16)}
            self.transparency_red = rgb[0]
            self.transparency_green = rgb[1]
            self.transparency_blue = rgb[2]
            if artwork.background_color == '#000000'
              self.print_with_black_ink = false
              self.cmy_gray = true
            end
          end
        end
      end

    end
  end

  def find_mass_line_for_arp
    MassLine.all.each do |mass_line|
      if self.sku.downcase.starts_with? mass_line.prefix.downcase and self.platen == mass_line.platen
        return mass_line
      end
    end
    nil
  end

  def file_exists_on_server?
    ftp = Net::FTP::new(Figaro.env['ftp_host'])
    ftp.login(Figaro.env['ftp_username'], Figaro.env['ftp_password'])
    ftp.passive = Figaro.env['ftp_passive']
    file = self.file_location.gsub("\\AATC\\", '').gsub('\\', '/')
    begin
      ftp.size(file)
    rescue Exception => e
      puts e
      return false
    end
    return true
  end

  def populate_info_from_mass_line(mass_line = nil)
    mass_line = find_mass_line_for_arp unless !mass_line.nil?
    if !mass_line.nil?
      self.file_location = file_location_from_mass_line mass_line
      self.machine_mode = mass_line.machine_mode
      self.platen = mass_line.platen
      self.resolution = mass_line.resolution
      self.ink = mass_line.ink
      self.ink_volume = mass_line.ink_volume
      self.highlight3 = mass_line.highlight3
      self.mask3 = mass_line.mask3
      self.highlightp = mass_line.highlightp
      self.maskp = mass_line.maskp
      self.print_with_black_ink = mass_line.print_with_black_ink
      self.cmy_gray = mass_line.cmy_gray
      self.multiple_pass = mass_line.multiple_pass
      self.transparency = mass_line.transparency
      self.transparency_red = mass_line.transparency_red
      self.transparency_blue = mass_line.transparency_blue
      self.transparency_green = mass_line.transparency_green
      self.tolerance = mass_line.tolerance
      self.choke_width = mass_line.choke_width
      self.white_color_pause = mass_line.white_color_pause
      self.unidirectional = mass_line.unidirectional
      self.width = mass_line.width
      self.height = mass_line.height
      self.from_top = mass_line.from_top
      self.from_center = mass_line.from_center
      self.pretreat_level = mass_line.pretreat_level
      self.requires_renaming = mass_line.requires_renaming
    end
  end

  def generate_custom_art_and_copy_locally
    customized_artwork_params = {}
    idea = find_mockbot_idea_for_arp
    customized_artwork_params['idea_id'] = "#{idea.id}"
    customized_artwork_params['print_location'] = PRINT_LOCATION_FRONT
    customized_artwork_params['imprint_size_id'] = PLATEN_MOCKBOT_CONVERSIONS[platen]
    customized_artwork_params['input_value'] = {}

    customizations.each do |customization|
      mb_customization = idea.customizations.find{|x| x.name == customization.mockbot_variable}.id
      customized_artwork_params['input_value']["#{mb_customization}"] = customization.value
    end

    customized_artwork = MockBot::CustomizedArtwork.create(
      customized_artwork: customized_artwork_params
    )
    self.update_attributes(
      custom_artwork_url: customized_artwork.file_url,
      customized_artwork_id: customized_artwork.id,
      file_location: file_location.gsub(".png", "_#{customized_artwork.id}.png")
    )

    File::open(local_filename, "wb") do |saved_file|
      open(custom_artwork_url, 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end

  def copy_custom_art_to_server
    # ftp the file to the ftp server
    # ftp = Net::FTP::new(Figaro.env['ftp_host'])
    # ftp.login(Figaro.env['ftp_username'], Figaro.env['ftp_password'])
    # ftp.passive = Figaro.env['ftp_passive']
    # file = self.file_location.gsub("\\AATC\\", '').gsub('\\', '/')
    # begin
    #   ftp.size(file)
    # rescue Exception => e
    #   puts e
    #   return false
    # end
    # return true

    # File.delete local_filename
  end

  def remove_custom_art_locally
    # File.delete local_filename
  end

  def custom_artwork_generated?
    !(custom_artwork_url.blank? || customized_artwork_id.blank?)
  end

  private

  def local_filename
    "#{LOCAL_ARTWORK_DIR}/#{File.basename(URI.parse(custom_artwork_url).path)}"
  end

  def downcase_sku
    self.sku = self.sku.downcase
  end

  def assign_static_values
    self.machine_mode = 'GT-381'
    self.resolution = 600
    self.white_color_pause = false unless !self.white_color_pause.blank?
    self.unidirectional = false unless !self.unidirectional.blank?
    self.multiple_pass = false unless !self.multiple_pass.blank?
    self.cmyk_ink_volume = 99.9
    self.white_ink_volume = 99.9
  end

  def default_file_location
    '\\\\AATC\\Retail\\ReadyToPublish\\' + self.sku.split('_')[0] + '\\' + self.sku.strip + '\\'+ self.sku.strip + self.platen.strip + '.png'
  end

  def file_location_from_mass_line(mass_line)
    location = mass_line.file_location_prefix
    if location[-1,1] != '\\'
      location = location + '\\'
    end
    "#{location}#{self.sku}#{self.platen}.png"
  end

  def in_inches(pixels, dpi)
    pixels = pixels.to_i
    dpi = dpi.to_i
    ((pixels * 1.0) / (dpi * 1.0)).round(1)
  end

  def get_max_pretreat_value(colors)
    color = colors.max {|a,b| get_pretreat_value(a) <=> get_pretreat_value(b)}
    get_pretreat_value(color)
  end

  def get_pretreat_value(color)
    pt_65 = ['Black', 'Charcoal', 'Chestnut','Dark Chocolate',
             'Dark Heather','Forest Green','Heather Maroon','
             Navy','Red','Royal Blue']

    pt_52 = ['Carolina Blue', 'Daisy', 'Heather Irish',
            'Honey', 'Indigo Blue', 'Irish Green',
            'Kiwi', 'Light Blue', 'Lime Green', 'Natural',
            'Orange', 'Sand', 'Sky', 'Sport Grey', 'Yellow']

    if pt_65.include? color
      return 65
    elsif pt_52.include? color
      return 52
    elsif color == 'White'
      return 0
    else
      return 65
    end

  end

end
