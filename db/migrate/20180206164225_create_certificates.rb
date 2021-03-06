class CreateCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :certificates do |t|
      t.references :signed_by, foreign_key: {to_table: :certificates}
      t.references :issuer, foreign_key: {to_table: :authorities}, null: false
      t.references :issuer_key, foreign_key: {to_table: :crypto_keys}, null: false
      t.references :subject, polymorphic: true, null: false
      t.references :subject_key, foreign_key: {to_table: :crypto_keys}, null: false
      t.references :profile, foreign_key: {to_table: :cert_profiles}, null: false
      t.text :pem, null: false
      t.datetime :revoked_at

      t.timestamps
    end
  end
end
