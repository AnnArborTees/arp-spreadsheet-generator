class AssignDefaultValuesToArpsAndMassLines < ActiveRecord::Migration
  def change
    change_column 'mass_lines', :ink_volume, :integer, default: 0
    change_column 'mass_lines', :highlight3, :integer, default: 0
    change_column 'mass_lines', :mask3, :integer, default: 0
    change_column 'mass_lines', :highlightp, :integer, default: 0
    change_column 'mass_lines', :maskp, :integer, default: 0
    change_column 'mass_lines', :transparency_red, :integer, default: 0
    change_column 'mass_lines', :transparency_blue, :integer, default: 0
    change_column 'mass_lines', :transparency_green, :integer, default: 0
    change_column 'mass_lines', :tolerance, :integer, default: 0
    change_column 'mass_lines', :choke_width, :integer, default: 0
    change_column 'arps', :ink_volume, :integer, default: 0
    change_column 'arps', :highlight3, :integer, default: 0
    change_column 'arps', :mask3, :integer, default: 0
    change_column 'arps', :highlightp, :integer, default: 0
    change_column 'arps', :maskp, :integer, default: 0
    change_column 'arps', :transparency_red, :integer, default: 0
    change_column 'arps', :transparency_blue, :integer, default: 0
    change_column 'arps', :transparency_green, :integer, default: 0
    change_column 'arps', :tolerance, :integer, default: 0
    change_column 'arps', :choke_width, :integer, default: 0
  end
end
