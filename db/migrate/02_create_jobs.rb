class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :builds do |t|
      t.references :task

      t.string :step
      t.integer :status
      t.text :output
      t.text :result

      t.timestamps
    end

    create_table :tasks do |t|
      t.references :project
      t.references :job

      t.timestamps
    end

    create_table :jobs do |t|
      t.string :runner_class_name
      t.text :params
      t.string :environment

      t.timestamps
    end
  end
end
