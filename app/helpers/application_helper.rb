# include MD5 gem, should be part of standard ruby install
require 'digest/md5'

module ApplicationHelper
  def gravatar_for(email, size: 50)

    # get the email from URL-parameters or what have you and make lowercase
    email_address = email.downcase

    # create the md5 hash
    hash = Digest::MD5.hexdigest(email_address)

    # compile URL which can be used in <img src="RIGHT_HERE"...
    image_tag "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon" #, width: size
  end
end
