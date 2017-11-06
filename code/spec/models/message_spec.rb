require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:conversation) }

  it { should validate_length_of(:text) }
end
