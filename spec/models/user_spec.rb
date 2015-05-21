require 'rails_helper'

describe User do
  let(:user) do
    User.new
  end

  it '#slug' do
    expect(user.slug).to eq('Fill this in by hand')
  end

  it '#to_param' do
    expect(user.to_param).to eq('Fill this in by hand')
  end
end
