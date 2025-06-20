class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions do |t|
      t.string :company_name, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.text :requirements
      t.text :identity_fields_required
      t.boolean :availability_required, default: false
      t.text :legal_disclosures
      t.text :video_questions
      t.text :other_information

      t.timestamps
    end
    
    add_index :positions, :company_name
    add_index :positions, :title
    add_index :positions, :location
  end
end