class AddJobIdToShifts < ActiveRecord::Migration[7.0]
  def change
    add_column :shifts, :job_id, :integer
    add_index :shifts, :job_id
  end
end
