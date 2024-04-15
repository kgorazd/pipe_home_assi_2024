class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :login, index: true
      t.string :password
      t.string :api_token, index: true

      t.timestamps
    end
  end
end
