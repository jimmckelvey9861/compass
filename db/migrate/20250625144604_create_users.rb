class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :full_name
      t.string :role
      t.integer :organization_id
      t.decimal :hourly_rate
      t.string :position
      t.string :phone

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :organization_id
  end
end
