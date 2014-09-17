class SpreadsheetsController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { redirect_to spreadsheets_path }
      failure.html { render }
    end
  end

  def generate_arps
    @spreadsheet = Spreadsheet.find(params[:id])
    @spreadsheet.arps.each do |arp|
      mass_line = arp.find_mass_line_for_arp
      if !mass_line.nil?
        arp.populate_info_from_mass_line
        arp.complete = true
        arp.save
        next
      end

      idea = arp.find_mockbot_idea_for_arp
      if !idea.nil?
        arp.populate_info_from_mockbot(idea)
        arp.complete = true
        arp.save
        next
      end
    end

    redirect_to @spreadsheet, notice: "ARP data has been generated for every ARP that possibly could"

  end

  def images_to_rename
    @spreadsheet = Spreadsheet.find(params[:id])
    respond_to do |format|
      format.html
      format.csv { send_data @spreadsheet.csv_download, filename: "arps_to_generate_batch_#{@spreadsheet.batch_id}.csv" }
    end
  end

  def download
    @spreadsheet = Spreadsheet.find(params[:id])
    respond_to do |format|
      format.csv { send_data @spreadsheet.csv_download, filename: "arps_to_generate_batch_#{@spreadsheet.batch_id}.csv" }
    end
  end

  def missing_arps
    @spreadsheet = Spreadsheet.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  private

  def spreadsheet_params
    params.require(:spreadsheet).permit(:file, :batch_id)
  end

end
