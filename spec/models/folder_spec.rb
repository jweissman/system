require 'rails_helper'

RSpec.describe Folder, type: :model do
  let(:root) { Folder.create }
  let(:usr) { root.children.create title: 'usr' }

  describe 'hierarchy' do
    it 'has a parent' do
      expect(usr.parent).to eq(root)
      expect(root.parent).to be_nil
    end

    it 'has children' do
      expect(root.children).to eq([usr])
      expect(usr.children).to be_empty
    end
  end

  describe 'paths' do
    it 'has an address' do
      expect(root.path).to eq '/'
      expect(usr.path).to eq '/usr'
    end
  end
end
