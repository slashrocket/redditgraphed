require 'rails_helper'

# dummy spec to have some skeleton, not real tests
describe SearchController do
  let(:search_controller) do
    SearchController.new
  end

  it '#results' do
    expect(search_controller.results).to eq('Exception in RSpec')
  end
end
