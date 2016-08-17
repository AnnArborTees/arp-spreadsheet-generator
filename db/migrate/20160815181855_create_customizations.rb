class CreateCustomizations < ActiveRecord::Migration
  def up
    create_table :customizations do |t|
      t.integer :arp_id
      t.string :spree_variable
      t.string :mockbot_variable
      t.string :value
      t.timestamps
    end

    execute("ALTER TABLE customizations MODIFY `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin;")

  end

  def down
    drop_table :customizations
  end
end
