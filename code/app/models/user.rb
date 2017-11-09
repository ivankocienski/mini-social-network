class User < ApplicationRecord

  has_secure_password

  validates_presence_of :name, :email, :password_digest

  has_many :created_conversations, foreign_key: :created_by_user_id, class_name: 'Conversation'
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users

  has_many :messages, dependent: :destroy

  def self.search(for_name)
    # this is not how you do 'proper' search
    where('name like ?', "%#{for_name}%").order(:name)
  end

end
