class CreateNotesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :notes_users do |t|
      t.references :note, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
