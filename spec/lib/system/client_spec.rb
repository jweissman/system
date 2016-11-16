require 'spec_helper'
require 'json'
require_relative '../../../lib/system/client'

# assumes system is running locally?
RSpec.describe 'system api client' do
  subject do
    System::API::Client.new("localhost", port: 3000)
  end

  context 'parses data into remote nodes' do
    it 'handles folders' do
      expect(subject.folders).not_to be_empty
    end
  end
end
