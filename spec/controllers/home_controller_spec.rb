require 'rails_helper'

# dummy spec to have some skeleton, not real tests
describe HomeController do
  let(:home_controller) do
    HomeController.new
  end

  it '#index' do
    expect(home_controller.index).to eq({ '5 minutes' => 5, '30 minutes' => 30, '1 hour' => 60, '6 hours' => 360, '12 hours' => 720, '24 hours' => 1440 })
  end

  it '#timeframe' do
    expect(home_controller.timeframe).to eq('Exception in RSpec')
  end

  it '#title' do
    expect(home_controller.title).to eq('Exception in RSpec')
  end
end
