class SpreadsheetsController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { redirect_to spreadsheets_path }
      failure.html { render }
    end
  end

  private

  def spreadsheet_params
    params.require(:spreadsheet).permit(:file, :batch_id)
  end

end
