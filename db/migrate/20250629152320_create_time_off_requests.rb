class CreateTimeOffRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :time_off_requests do |t|
      t.integer :user_id, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :reason
      t.string :status, null: false, default: 'pending'
      t.integer :approved_by_id
      t.text :notes

      t.timestamps
    end

    add_index :time_off_requests, :user_id
    add_index :time_off_requests, :status
  end
end
