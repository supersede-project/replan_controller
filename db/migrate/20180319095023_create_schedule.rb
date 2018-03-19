class CreateSchedule < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.integer :week
      t.integer :dayOfWeek
      t.decimal :beginHour
      t.decimal :endHour
      t.integer :status
      t.references :resource, foreign_key: true
      t.references :feature, foreign_key: true
      t.references :plan, foreign_key: true
    end
  end
end
