class ArpsController < InheritedResources::Base

  def edit
    @arp = Arp.find(params[:id])
    if params[:source] == 'mass_line'
      @mass_line = @arp.find_mass_line_for_arp
      if @mass_line.nil?
        flash[:error] = "No mass line exists that could match #{@arp.sku}, create one now!"
        redirect_to new_mass_line_path
      else
        @arp.populate_info_from_mass_line(@mass_line)
      end
    end
  end

  def generate
    arp = Arp.find(params[:id])
    mass_line = arp.find_mass_line_for_arp
    idea = arp.find_mockbot_idea_for_arp

    if !mass_line.nil?
      arp.populate_info_from_mass_line
      arp.complete = true
      arp.save
      redirect_to spreadsheet_path(arp.spreadsheet), notice: "Generated ARP #{arp.sku} Data from Mass Line #{mass_line.prefix}"
    elsif !idea.nil?
      arp.populate_info_from_mockbot(idea)
      arp.complete = true
      arp.save
      redirect_to spreadsheet_path(arp.spreadsheet), notice: "Generated ARP #{arp.sku} Data from MockBot Idea"
    else
      flash[:error] = "Failed to match ARP #{arp.sku} with either a mass line or a MockBot idea"
      redirect_to spreadsheet_path(arp.spreadsheet)
    end


  end

end
