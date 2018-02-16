class CreateAuthoritiesCsr < ActiveRecord::Migration[5.1]
  def change
    create_table "authorities_csr" do |t|
      t.integer :authority_id
      t.integer :csr_id
    end
  end
end
