class CreateCertSigningRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :cert_signing_requests do |t|
      t.references :subject, polymorphic: true, null: false
      t.references :profile, foreign_key: {to_table: :cert_profiles}
      t.text :pem

      t.timestamps
    end
  end
end
