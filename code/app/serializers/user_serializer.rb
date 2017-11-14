class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :joined

  def joined
    object.created_at
  end
end
