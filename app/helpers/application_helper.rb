# include MD5 gem, should be part of standard ruby install
require 'digest/md5'

module ApplicationHelper
  def maybe_remote_user_path(user, &blk)
    if user.is_a?(System::API::User)
      page_url("/usr/#{user.name}", host: user.host, port: 80)
    elsif user.is_a?(User)
      page_url("/usr/#{user.name}")
    end
  end

  def maybe_virtual_link_to(resource, &blk)
    return (link_to page_url('/'), &blk) if resource.path == '/'
    path = resource.path.sub!(/^\//, '')
    link_to page_url(path), &blk
  end

  def gravatar_for(email, size: 50)
    # get the email from URL-parameters or what have you and make lowercase
    email_address = email.downcase

    # create the md5 hash
    hash = Digest::MD5.hexdigest(email_address)

    # compile URL which can be used in <img src="RIGHT_HERE"...
    image_tag "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon" #, width: size
  end

  def markdown(text)
    text_with_tags = linkify_hashtags(text)
    markdown_to_html.render(text_with_tags).html_safe #"This is *bongos*, indeed.")
  end

  def linkify_hashtags(text)
    new_content = text.dup
    Tag.match(text).each do |name|
      new_content.gsub!(/##{name}/,"[##{name}](/tags/#{name})")
    end
    new_content
  end

  def markdown_to_html
    renderer = Redcarpet::Render::HTML.new
    @markdown_to_html ||= Redcarpet::Markdown.new(renderer) #, extensions = {})
  end
end
