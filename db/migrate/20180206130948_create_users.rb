class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :firstname
      t.string :lastname
      t.string :street
      t.string :street2
      t.string :city
      t.string :zip
      t.string :country
      t.string :state
      t.string :phone
      t.text :sign_key_pem
      t.text :encrypt_key_pem

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
