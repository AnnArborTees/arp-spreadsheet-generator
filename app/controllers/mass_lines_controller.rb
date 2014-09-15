class MassLinesController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { redirect_to mass_lines_path }
      failure.html { render }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to mass_lines_path }
      failure.html { render }
    end
  end

  def process_spreadsheet
    errors = MassLine.generate_from_csv(params[:csv].tempfile.to_path)
    if errors.empty?
      redirect_to mass_lines_path, notice: 'Sucessfully added/updated all Mass Lines from Spreadsheet'
    else
      redirect_to mass_lines_path, error: "Added/Updated Mass Lines, but had errors with #{errors.join(', ')}"
    end

  end

  private

  def mass_line_params
    params.require(:mass_line).permit(
        :prefix, :file_location_prefix, :machine_mode, :platen, :resolution, :ink,
        :highlight3, :mask3, :highlightp, :maskp, :print_with_black_ink, :cmy_gray, :multiple_pass,
        :transparency, :transparency_red, :transparency_blue, :transparency_green, :tolerance,
        :choke_width, :white_color_pause, :unidirectional, :width, :height, :from_top, :from_center,
        :pretreat_level
    )
  end

end
