class FixCmykInkVolume < ActiveRecord::Migration
  def change
    rename_column :arps, :cmyk_ink_colume, :cmyk_ink_volume
  end
end
