class InitialSetup < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :repository
      t.integer :rank
      t.text :raw_data
      t.timestamps
    end

    create_table :dependencies do |t|
      t.references :project
      t.references :depends_on, references: :projects
      t.string :kind
      t.text :raw_data
      t.timestamps
    end

    create_table :repositories do |t|
      t.string :type
      t.string :host
      t.string :owner
      t.string :name
      t.integer :size
      t.text :raw_data
      t.timestamps
    end
  end
end
