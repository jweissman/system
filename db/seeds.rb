# create root user
root = User.create(
  email: "joe@bignerdranch.com",
  name: "root",
  password: "admin1",
  password_confirmation: "admin1"
)

root.save

# create root directory
slash = Folder.create(title: 'root', user: root)

# create basic structure
usr = slash.children.create(title: 'usr')
sys = slash.children.create(title: 'sys')

# create some other root dirs
slash.children.create(title: 'proc')
slash.children.create(title: 'lib')
slash.children.create(title: 'etc')

usr.save

# create some regular users
# wonder woman
diana = User.create(
  email: "diana.prince@bignerdranch.com",
  name: 'dprince',
  password: 'freedom',
  password_confirmation: 'freedom'
)

diana.save
diana_home = usr.children.create(title: "dprince", user: diana)
diana_friends = diana_home.children.create(title: "friends", user: diana)

diana_home.nodes.create(title: "about", content: "first")
diana_minutes = diana_home.children.create(title: "minutes")
diana_minutes.nodes.create(title: "diana 10am", content: "cleaning up")

# supes
supes = User.create(
  email: "clark.kent@bignerdranch.com",
  name: "ckent",
  password: "justice",
  password_confirmation: "justice"
)

supes.save
supes_home = usr.children.create(title: "ckent", user: supes)

supes_home.nodes.create(title: "about", content: "soaring overhead")
supes_minutes = supes_home.children.create(title: "minutes")
supes_minutes.nodes.create(title: "supes 11am", content: "chilling")

Mount.create(source: supes_home, target: diana_friends)

# initialize system status
sys.nodes.create(title: "status", content: "hello world")
