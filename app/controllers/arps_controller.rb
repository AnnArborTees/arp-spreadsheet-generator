class ArpsController < InheritedResources::Base

  def customize
    arp = Arp.find(params[:id])
    arp.generate_custom_art_and_copy_locally
    arp.copy_custom_art_to_server
    arp.remove_custom_art_locally
    redirect_to spreadsheet_path(arp.spreadsheets.first)
  end

  def generate
    arp = Arp.find(params[:id])
    mass_line = arp.find_mass_line_for_arp
    idea = arp.find_mockbot_idea_for_arp

    if !mass_line.nil?
      arp.populate_info_from_mass_line
      arp.complete = true
      arp.save
      redirect_to spreadsheet_path(arp.spreadsheets.first), notice: "Generated ARP #{arp.sku} Data from Mass Line #{mass_line.prefix}"
    elsif !idea.nil?

      if arp.customizable? && CustomizableLine.exists?(sku: arp.sku)
        line = CustomizableLine.find_by(sku: arp.sku)
        arp.update_attribute(:customizable_line, line)
        arp.customizations.each do |x|
          x.update_attribute(:mockbot_variable, line.mockbot_variable_name)
        end
      end

      arp.populate_info_from_mockbot(idea)
      arp.complete = true
      arp.save
      redirect_to spreadsheet_path(arp.spreadsheets.first), notice: "Generated ARP #{arp.sku} Data from MockBot Idea"
    else
      flash[:error] = "Failed to match ARP #{arp.sku} with either a mass line or a MockBot idea"
      redirect_to spreadsheet_path(arp.spreadsheets.first)
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to spreadsheet_path @arp.spreadsheets.last }
      failure.html { render }
    end
  end

  private

  def arp_params
    params.require(:arp).permit(
        :sku, :file_location, :machine_mode, :platen, :resolution, :ink,
        :highlight3, :mask3, :highlightp, :maskp, :print_with_black_ink, :cmy_gray, :multiple_pass,
        :transparency, :transparency_red, :transparency_blue, :transparency_green, :tolerance,
        :choke_width, :white_color_pause, :unidirectional, :width, :height, :from_top, :from_center,
        :pretreat_level, :cmyk_ink_volume, :white_ink_volume, :requires_renaming, :complete, :customizable,
        :customizable_line_id,
        customizations_attributes: [:arp_id, :spree_variable, :mockbot_variable, :value, :_destroy, :id]
    )
  end

end
