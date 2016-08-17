class CustomizableLinesController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { redirect_to customizable_lines_path }
      failure.html { render }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to customizable_lines_path }
      failure.html { render }
    end
  end

  private

  def customizable_line_params
    params.require(:customizable_line).permit(
      :sku, :spree_variable_name, :mockbot_variable_name,
      :case_sensitive
    )
  end

end
