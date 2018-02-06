class CreateCertProfileConstraints < ActiveRecord::Migration[5.1]
  def change
    create_table :cert_profile_constraints do |t|
      t.references :profile, foreign_key: {to_table: :cert_profiles}, null: false
      t.string :type, null: false
      t.jsonb :value, null: false

      t.timestamps
    end
  end
end
