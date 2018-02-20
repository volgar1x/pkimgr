class CreateAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_table :authorities do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :website
      t.string :password_digest, null: false
      t.string :city
      t.string :zip
      t.string :country
      t.string :state
      t.string :organization
      t.bigint :next_serial, null: false, default: 1

      t.timestamps
    end
    add_index :authorities, :name, unique: true
    add_index :authorities, :email, unique: true
  end
end
