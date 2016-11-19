require 'rails_helper'

RSpec.describe Folder, type: :model do
  let(:admin) { User.create(name: "admin", email: "dev-test@bignerdranch.com", password: 'testing', password_confirmation: 'testing') }

  let(:root) { Folder.create(user: admin, title: "root") }

  let(:usr) { Folder.create(user: admin, title: "usr", parent: root) }

  # root.children.create title: 'usr' }
  let(:opt) { Folder.create(user: admin, title: "opt", parent: root) }
  let(:lib) { Folder.create(user: admin, title: "lib", parent: root) }

  let(:etc) { Folder.create(user: admin, title: "etc", parent: root) }

  describe 'themes' do
    it 'is unthemed by default (standard sys view)' do
      expect(root).not_to be_themed
    end

    it 'can have a theme' do
      root.theme = 'blog'
      expect(root).to be_themed
    end
  end

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
      expect(usr.path).to eq '/usr/'
    end
  end

  describe 'mounts' do
    let!(:mount) do
      # overlay /opt on /usr
      Mount.create(source: opt, target: usr)
    end

    let!(:shared_folder) do
      Folder.create(user: admin, title: "shared", parent: opt)
    end

    let!(:shared_file) do
      shared_folder.nodes.create(title: "hello", content: "world")
    end

    let!(:another_mount) do
      Mount.create(source: lib, target: usr)
    end

    let!(:another_shared_folder) do
      Folder.create(user: admin, title: "shared", parent: lib)
    end

    let!(:another_shared_file) do
      another_shared_folder.nodes.create(title: "hey", content: "there")
    end

    it 'can be overlaid' do
      expect(usr.mount_targets).to include(mount)

      # why do we need to reload now? this was working :/
      expect(usr.reload.overlays).to include(opt)
    end

    it 'virtualizes children' do
      expect(usr.reload.virtual_children).not_to be_empty

      virtual_folder = usr.reload.virtual_children.first
      expect(virtual_folder.title).to eq(shared_folder.title)
      expect(virtual_folder.path).to eq("/usr/shared/")

      vnode_names = virtual_folder.virtual_nodes.map(&:title)
      expect(vnode_names).to include(shared_file.title)
      expect(vnode_names).to include(another_shared_file.title)
    end

    let!(:symlink) do
      Symlink.create(source_path: '/usr/shared', target: etc)
    end

    it 'can be symbolically overlaid' do
      expect(etc.symbolic_overlays).to eq(['/usr/shared'])

      expect(etc.symbolic_nodes.map(&:title)).to include(shared_file.title)
      expect(etc.symbolic_nodes.map(&:title)).to include(another_shared_file.title)
    end
  end
end
