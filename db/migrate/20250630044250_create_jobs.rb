class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.integer :organization_id, null: false
      t.string :name, null: false
      t.text :description
      t.text :required_skills
      t.integer :min_experience_months, default: 0
      t.decimal :pay_rate, precision: 10, scale: 2
      t.string :pay_type, default: 'hourly'
      t.string :status, default: 'active'

      t.timestamps
    end

    add_index :jobs, :organization_id
    add_index :jobs, :status
  end
end