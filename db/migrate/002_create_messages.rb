class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :title
      t.string :content
      t.integer :message_id,          uniqueness: true
      t.integer :recipient_id
      t.integer :sender_id

      t.timestamps            null: true
    end
  end

  def self.down
    drop_table :messages
  end
end
