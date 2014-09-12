class AddStateToArp < ActiveRecord::Migration
  def change
    add_column :arps, :complete, :boolean
    add_index :arps, :complete
  end
end
