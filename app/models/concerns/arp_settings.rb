module ArpSettings
  extend ActiveSupport::Concern

  included do

    before_save :fix_transparency

    private

    def fix_transparency
      if !self.transparency?
        self.transparency_red = 0
        self.transparency_green = 0
        self.transparency_blue = 0
      end
    end

  end

end