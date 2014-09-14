class AddPretreatLevelToArpAndMassLine < ActiveRecord::Migration
  def change
    add_column :arps, :pretreat_level, :integer
    add_column :mass_lines, :pretreat_level, :integer
  end
end
