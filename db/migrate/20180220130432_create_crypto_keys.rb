class CreateCryptoKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :crypto_keys do |t|
      t.string :name, null: false
      t.references :owner, polymorphic: true
      t.text :private_pem, null: false
      t.text :public_pem, null: false

      t.timestamps
    end
  end
end
