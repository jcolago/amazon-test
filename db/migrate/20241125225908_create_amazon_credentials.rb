class CreateAmazonCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :amazon_credentials do |t|
      t.string :access_token
      t.string :refresh_token

      t.timestamps
    end
  end
end