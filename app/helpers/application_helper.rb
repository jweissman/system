# include MD5 gem, should be part of standard ruby install
require 'digest/md5'

module ApplicationHelper
  def maybe_virtual_link_to(resource, &blk)
    return (link_to page_url('/'), &blk) if resource.path == '/'

    path = resource.path.sub!(/^\//, '')
    # path = resource.path[-1..1] # without leading slash..
    link_to page_url(path), &blk
    # if resource.is_a?(VirtualFolder)
    # #  link_to virtual_folder_path(resource.attributes), &blk
    # #elsif resource.is_a?(VirtualNode)
    # #  link_to virtual_node_path(resource.attributes), &blk
    # else
    #   link_to resource, &blk
    # end
  end

  def gravatar_for(email, size: 50)
    # get the email from URL-parameters or what have you and make lowercase
    email_address = email.downcase

    # create the md5 hash
    hash = Digest::MD5.hexdigest(email_address)

    # compile URL which can be used in <img src="RIGHT_HERE"...
    image_tag "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon" #, width: size
  end
end
