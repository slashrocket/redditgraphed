require 'rails_helper'

# dummy spec to have some skeleton, not real tests
describe PostController do
  let(:post_controller) do
    PostController.new
  end

  it '#show' do
    expect(post_controller.show).to eq('Exception in RSpec')
  end

  it '#timeframe' do
    expect(post_controller.timeframe).to eq('Exception in RSpec')
  end
end
