class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.boolean :isCurrent
      t.decimal :priorityQuality
      t.decimal :performanceQuality
      t.decimal :similarityQuality
      t.decimal :globalQuality
      t.references :release, foreign_key: true
      t.timestamps
    end
  end
end
