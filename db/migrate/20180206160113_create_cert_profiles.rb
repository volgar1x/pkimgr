class CreateCertProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :cert_profiles do |t|
      t.string :name

      t.timestamps
    end
  end
end
