class CreateCertSigningRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :cert_signing_requests do |t|
      t.references :subject, polymorphic: true, null: false
      t.references :subject_key, foreign_key: {to_table: :crypto_keys}, null: false
      t.references :profile, foreign_key: {to_table: :cert_profiles}, null: false
      t.references :certificate
      t.string :name, null: false
      t.text :pem, null: false

      t.timestamps
    end
  end
end
