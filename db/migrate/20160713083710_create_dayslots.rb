class CreateDayslots < ActiveRecord::Migration[5.0]
  def change
    create_table :dayslots do |t|
      t.integer :code
      t.integer :week
      t.integer :dayOfWeek
      t.decimal :beginHour
      t.decimal :endHour
      t.integer :slotStatus, default: 0
      t.references :feature, foreign_key: true
      t.references :resource, foreign_key: true
      t.references :project, foreign_key: true
    end
  end
end
