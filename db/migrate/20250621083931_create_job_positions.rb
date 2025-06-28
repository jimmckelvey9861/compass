class CreateJobPositions < ActiveRecord::Migration[7.0]
  def change
    create_table :job_positions do |t|
      t.string :title
      t.string :status

      t.timestamps
    end
  end
end
