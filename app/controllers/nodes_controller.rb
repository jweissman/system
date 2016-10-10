class NodesController < ApplicationController
  def index
    @nodes = Node.all
  end

  def show
    @node = Node.find(params.require(:id))
  end

  def new
    folder = Folder.find(node_params[:folder_id])
    @node = Node.new(folder: folder)
  end

  def create
    @node = Node.new(node_params)
    if @node.save then
      redirect_to node_path(@node), notice: "node '#{@node.title}' created"
    else
      flash[:alert] = "There was a problem..."
      redirect_to nodes_url
    end
  end

  def edit
    @node = Node.find(params.require(:id))
  end

  def update
    @node = Node.find(node_params[:id])
    @node.update(node_params)

    if @node.save then
      redirect_to node_path(@node), notice: "Node '#{@node.title}' updated"
    else
      flash[:alert] = "Oh no...."
      redirect_to node_path(@node)
    end
  end

  private
    def node_params
      params.require(:node).permit(:id, :title, :content, :folder_id)
    end
end
