class CreateBlockedList < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.integer :blocked_by
      t.integer :blocked
    end
  end

  def self.down
    drop_table :blocks
  end
end
