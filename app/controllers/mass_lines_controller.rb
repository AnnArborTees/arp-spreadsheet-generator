class MassLinesController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { redirect_to mass_lines_path }
      failure.html { render }
    end
  end

  private

  def mass_line_params
    params.require(:mass_line).permit(
        :prefix, :file_location_prefix, :machine_mode, :platen, :resolution, :ink,
        :highlight3, :mask3, :highlightp, :maskp, :print_with_black_ink, :cmy_gray, :multiple_pass,
        :transparency, :transparency_red, :transparency_blue, :transparency_green, :tolerance,
        :choke_width, :white_color_pause, :unidirectional, :width, :height, :from_top, :from_center
    )
  end

end
