require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }

  describe '::search' do
    let(:user) { create(:user) }
    let(:long_user) { create :user, name: 'a-user-name-like-no-other' }

    it 'finds users by name' do
      results = User.search(user.name)
      expect(results.first).to eq(user)
    end

    it 'finds rough matches' do
      long_user

      results = User.search('name-like')
      expect(results.first).to eq(long_user)
    end
  end
end
