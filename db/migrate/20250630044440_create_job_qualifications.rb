class CreateJobQualifications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_qualifications do |t|
      t.integer :user_id, null: false
      t.integer :job_id, null: false
      t.boolean :certified, default: false
      t.date :certified_date
      t.text :notes

      t.timestamps
    end

    add_index :job_qualifications, :user_id
    add_index :job_qualifications, :job_id
    add_index :job_qualifications, [:user_id, :job_id], unique: true
  end
end