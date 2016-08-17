class CreateCustomizableLines < ActiveRecord::Migration
  def change
    create_table :customizable_lines do |t|
      t.string :sku
      t.string :spree_variable_name, index: true
      t.string :mockbot_variable_name, index: true
      t.boolean :case_sensitive, index: true
      t.timestamps
    end

    add_column :arps, :customizable_line_id, :integer, index: true
    add_column :arps, :customizable, :boolean, index: true
    add_column :arps, :custom_artwork_url, :string, index: true
    add_column :arps, :customized_artwork_id, :integer
  end
end
