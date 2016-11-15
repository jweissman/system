class VirtualNodesController < ApplicationController
  def show
    Rails.logger.info "vnode params: #{virtual_node_params}"

    @virtual_node = VirtualNode.new(
      title: virtual_node_params[:title],
      parent_path: virtual_node_params[:parent_path]
    )

    @path_components = Path.analyze(@virtual_node.path)
  end

  private
    def virtual_node_params
      params.permit(:title, :parent_path)
    end
end
