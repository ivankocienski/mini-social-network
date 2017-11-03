class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations do |t|
      t.references :created_by_user
      t.string :state

      t.timestamps
    end
  end
end
