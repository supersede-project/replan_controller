class CreateJoinTableDayslotsResources < ActiveRecord::Migration[5.1]
  def change
    create_join_table :dayslots, :resources do |t|
      # t.index [:dayslot_id, :resource_id]
      # t.index [:resource_id, :dayslot_id]
    end
  end
end
