require 'rails_helper'

# dummy spec to have some skeleton, not real tests
describe User do
  let(:user) do
    User.new
  end

  it '#slug' do
    expect(user.slug).to eq(nil)
  end

  it '#to_param' do
    expect(user.to_param).to eq(nil)
  end
end
