class CreateArps < ActiveRecord::Migration
  def change
    create_table :arps do |t|
      t.string :file_location
      t.string :machine_mode
      t.string :sku
      t.string :platen
      t.integer :resolution
      t.string :ink
      t.integer :ink_volume
      t.integer :highlight3
      t.integer :mask3
      t.integer :highlightp
      t.integer :maskp
      t.boolean :print_with_black_ink
      t.boolean :cmy_gray
      t.boolean :multiple_pass
      t.boolean :transparency
      t.integer :transparency_red
      t.integer :transparency_blue
      t.integer :transparency_green
      t.integer :tolerance
      t.integer :choke_width
      t.boolean :white_color_pause
      t.boolean :unidirectional

      t.decimal :width, precision: 5, scale: 2
      t.decimal :height, precision: 5, scale: 2
      t.decimal :from_top, precision: 5, scale: 2
      t.decimal :from_center, precision: 5, scale: 2
      t.decimal :cmyk_ink_colume, precision: 5, scale: 2
      t.decimal :white_ink_volume, precision: 5, scale: 2

      t.timestamps
    end

    add_index :arps, :sku
    add_index :arps, :platen

  end
end
