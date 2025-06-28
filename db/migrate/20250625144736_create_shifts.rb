class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.integer :organization_id
      t.integer :assigned_user_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :role
      t.string :location
      t.string :status, default: 'scheduled'

      t.timestamps
    end
    add_index :shifts, :organization_id
    add_index :shifts, :assigned_user_id
    add_index :shifts, :start_time
  end
end