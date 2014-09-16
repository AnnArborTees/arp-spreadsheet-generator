class AddRequiresRenamingToArpAndMassLine < ActiveRecord::Migration
  def change
    add_column :arps, :requires_renaming, :boolean, default: false
    add_column :mass_lines, :requires_renaming, :boolean, default: false
    add_index :arps, :requires_renaming
    add_index :mass_lines, :requires_renaming
  end
end
