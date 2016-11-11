require 'rails_helper'

RSpec.describe Folder, type: :model do
  let(:admin) { User.create(name: "admin") }

  let(:root) { Folder.create(user: admin, title: "root") }
  let(:usr) { Folder.create(user: admin, title: "usr", parent: root) } #root.children.create title: 'usr' }

  # before do
  #   root.save
  #   usr.save
  # end

  describe 'hierarchy' do
    it 'has a parent' do
      expect(usr.parent).to eq(root)
      expect(root.parent).to be_nil
    end

    it 'has children' do
      expect(root.children).to include(usr)
      expect(usr.children).to be_empty
    end
  end

  describe 'paths' do
    it 'has an address' do
      expect(root.path).to eq '/'
      expect(usr.path).to eq 'root/usr'
    end
  end
end
