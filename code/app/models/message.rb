class Message < ApplicationRecord

  belongs_to :user
  belongs_to :conversation

  validates_presence_of :text, :conversation, :user
  validates :text, length: { in: 2..256 }

end
