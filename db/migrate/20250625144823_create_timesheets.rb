class CreateTimesheets < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheets do |t|
      t.integer :user_id
      t.integer :shift_id
      t.datetime :clock_in_time
      t.datetime :clock_out_time
      t.string :status, default: 'pending'
      t.decimal :hours_worked, precision: 10, scale: 2

      t.timestamps
    end
    add_index :timesheets, :user_id
    add_index :timesheets, :shift_id
  end
end