module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:current_user])
  end

  def nav_item(body, path, options = {}, &block)
    if block
      options = path
      path = body
      body = block.call
    end

    classes = "nav-item"
    if path == request.fullpath
      classes += " active"
    end

    content_tag(:li, body, class: classes)
  end

  def nav_link(name, path, options = {}, &block)
    options[:class] ||= ""
    options[:class] += " nav-link"

    nav_item(link_to(name, path, options, &block), path)
  end
end
