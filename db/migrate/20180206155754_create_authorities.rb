class CreateAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_table :authorities do |t|
      t.string :name
      t.string :email
      t.string :website
      t.string :password_digest
      t.text :sign_key_pem
      t.text :encrypt_key_pem

      t.timestamps
    end
    add_index :authorities, :name, unique: true
    add_index :authorities, :email, unique: true
    add_index :authorities, :website, unique: true
  end
end
