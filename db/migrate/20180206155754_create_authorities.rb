class CreateAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_table :authorities do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :website
      t.string :password_digest, null: false
      t.text :sign_key_pem
      t.text :encrypt_key_pem

      t.timestamps
    end
    add_index :authorities, :name, unique: true
    add_index :authorities, :email, unique: true
  end
end
