class AddFieldsToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :required_languages, :text
    add_column :jobs, :color, :string, default: '#3B82F6'
  end
end