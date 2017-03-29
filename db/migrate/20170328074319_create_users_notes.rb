class CreateUsersNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :users_notes do |t|
      t.references :user
      t.references :note

      t.timestamps
    end
  end
end
