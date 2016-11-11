module Navigation
  def home_folder_or_root
    slash = Folder.root #find_by(parent: nil)
    return slash unless user_signed_in?

    # find or create home folder for this user...
    # todo need a dsl for this!
    usr = Folder.find_or_create_by(parent: slash, title: 'usr')

    Folder.find_or_create_by(parent: usr, title: current_user.name)
  end
end
