class AddElapsedTime < ActiveRecord::Migration[5.0]
  def change
    change_table :builds do |t|
      t.integer :elapsed_time
    end
  end
end
