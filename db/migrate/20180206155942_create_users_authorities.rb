class CreateUsersAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :authorities do |t|
      t.index :user_id
      t.index :authority_id
    end
  end
end
