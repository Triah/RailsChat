class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.belongs_to :chat_room
      t.string :content
      t.belongs_to :user

      t.timestamps
    end
  end
end
