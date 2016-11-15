require 'rails_helper'

RSpec.describe Path, type: :model do
  let(:admin) do
    User.create(name: 'admin')
  end

  let!(:root) do
    Folder.create(parent: nil, title: 'root', user: admin)
  end

  let!(:hello) do
    root.nodes.create(title: 'hello', content: 'world')
  end

  let!(:opt) do
    Folder.create(parent: root, title: 'opt', user: admin)
  end

  let!(:sample) do
    opt.nodes.create(title: 'sample', content: 'lorem ipsum')
  end

  let!(:etc) do
    Folder.create(parent: opt, title: 'etc', user: admin)
  end

  let!(:okay) do
    etc.nodes.create(title: 'okay', content: 'yep')
  end

  let!(:lib) do
    Folder.create(parent: etc, title: 'lib', user: admin)
  end

  let!(:somelib) do
    lib.nodes.create(title: 'somelib', content: 'example')
  end

  context '#refer' do
    it 'should find folders' do
      expect(Path.dereference('/')).to eq(root)
    end

    it 'should find files' do
      expect(Path.dereference('/hello')).to eq(hello)
    end

    it 'should find subfolders' do
      expect(Path.dereference('/opt/')).to eq(opt)
      expect(Path.dereference('/opt/etc/')).to eq(etc)
    end

    it 'should find files in subfolders' do
      expect(Path.dereference('/opt/etc/okay')).to eq(okay)
    end

    context 'virtual overlays' do
      let!(:usr) do
        Folder.create(parent: root, title: 'usr', user: admin)
      end

      let!(:mount) do
        Mount.create(source: opt, target: usr)
      end

      it 'should find virtual nodes' do
        vnode = Path.dereference('/usr/sample')
        expect(vnode).to be_a(VirtualNode)
        expect(vnode.title).to eq('sample')
      end

      it 'should find virtualized nodes within virtual folders' do
        vnode = Path.dereference('/usr/etc/okay')
        expect(vnode).to be_a(VirtualNode)
        expect(vnode.title).to eq('okay')
      end

      it 'should find deeply-nested virtual nodes' do
        vnode = Path.dereference('/usr/etc/lib/somelib')
        expect(vnode).to be_a(VirtualNode)
        expect(vnode.title).to eq('somelib')
      end

      let!(:blog) do
        Folder.create(parent: opt, title: 'blog', user: admin)
      end

      let!(:book) do
        Folder.create(parent: etc, title: 'book', user: admin)
      end

      it 'should find virtual children' do
        vchild = Path.dereference('/usr/blog/')
        expect(vchild).to be_a(VirtualFolder)
        expect(vchild.title).to eq('blog')

        vchild = Path.dereference('/usr/etc/')
        expect(vchild).to be_a(VirtualFolder)
        expect(vchild.title).to eq('etc')
      end

      it 'should find nested virtual children' do
        vchild = Path.dereference('/usr/etc/book/')
        expect(vchild).to be_a(VirtualFolder)
        expect(vchild.title).to eq('book')
      end
    end
  end

  context '#decompose' do
    it 'should handle root' do
      expect(Path.decompose('/')).to eq(['/'])
    end

    it 'should break apart path components' do
      expect(Path.decompose('/usr/sys')).to eq(['/','/usr', '/usr/sys'])
      expect(Path.decompose('/opt/etc/okay')).to eq(['/','/opt', '/opt/etc', '/opt/etc/okay'])
      expect(Path.decompose('/a/b/c/d/e/f')).to eq(['/', '/a', '/a/b', '/a/b/c', '/a/b/c/d', '/a/b/c/d/e', '/a/b/c/d/e/f'])
    end
  end

  context "#analyze" do
    it 'should reify root' do
      expect(Path.analyze('/')).to eq([root])
    end

    it 'should reify nested paths' do
      expect(Path.analyze('/opt/etc/okay')).to eq([root, opt, etc, okay])
    end
  end
end
