class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :title
      t.string :content
      t.integer :recipient_id
      t.integer :sender_id
      t.boolean :read,                default: false

      t.timestamps                    null: true
    end
  end

  def self.down
    drop_table :messages
  end
end
