class CreateApiSettings < ActiveRecord::Migration
  def change
    create_table :api_settings do |t|
      t.string :type

      t.string :homepage
      t.string :api_endpoint

      t.string :auth_email
      t.string :auth_token
    end

    add_index :api_settings, :type, unique: true
  end
end
