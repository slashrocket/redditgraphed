require 'rails_helper'

# dummy spec to have some skeleton, not real tests
describe UserPagesController do
  let(:user_pages_controller) do
    UserPagesController.new
  end

  it '#index' do
    expect(user_pages_controller.index).to eq('Exception in RSpec')
  end

  it '#show' do
    expect(user_pages_controller.show).to eq('Exception in RSpec')
  end

  it '#save' do
    expect(user_pages_controller.save).to eq('Exception in RSpec')
  end
end
