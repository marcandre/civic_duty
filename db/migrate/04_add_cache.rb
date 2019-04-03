class AddCache < ActiveRecord::Migration[5.0]
  def change
    change_table :tasks do |t|
      t.integer :total_elapsed_time
      t.text :summary
      t.text :synthesis
      t.integer :status, default: 0
      t.string :stage, default: :_started_
    end
  end
end
