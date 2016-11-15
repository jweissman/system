class PagesController < ApplicationController
  include Navigation

  def show
    # find a path..
    path = '/' + params.require(:path)
    target = Path.dereference(path)
    not_found(path) unless target
    if target.is_a?(VirtualFolder)
      redirect_to virtual_folder_path(target.attributes), notice: "Virtual folder #{path} found!"
    elsif target.is_a?(VirtualNode)
      redirect_to virtual_node_path(target.attributes), notice: "Virtual node #{path} found!"
    else
      redirect_to target, notice: "Path #{path} found!"
    end
  end

  def not_found(path)
    raise ActionController::RoutingError.new("Not found: #{path}")
  end
end
