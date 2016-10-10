# create root directory
root = Folder.create(title: 'root')

# create basic structure
usr = root.children.create(title: 'usr')
sys = root.children.create(title: 'sys')

# create admin user
admin = usr.children.create(title: "admin")
admin_home = admin.children.create(title: "home")

admin_home.nodes.create(title: "about", content: "first")

# initialize system status
sys.nodes.create(title: "status", content: "hello world")
