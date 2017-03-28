class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :title
      t.string :location
      t.text :text
      t.text :summary
      t.references :creator

      t.timestamps
    end
  end
end
