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

end
