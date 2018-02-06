class CreateCertProfileConstraints < ActiveRecord::Migration[5.1]
  def change
    create_table :cert_profile_constraints do |t|
      t.references :profile, foreign_key: {to_table: :cert_profiles}
      t.string :type
      t.jsonb :value

      t.timestamps
    end
  end
end
