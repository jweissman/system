class NodesController < ApplicationController
  def index
    @nodes = Node.all
  end

  # def show
  #   @show_folder_listing = false
  #   @node = Node.find(params.require(:id))
  #   redirect_to page_url(@node.path)
  # end

  def new
    folder = Folder.find(node_params[:folder_id])
    @node = Node.new(folder: folder)
  end

  def create
    @node = Node.new(node_params)
    if @node.save then
      redirect_to page_url(@node.path), notice: "node '#{@node.title}' created"
    else
      flash[:alert] = "There was a problem..."
      redirect_to root_url
    end
  end

  def edit
    @node = Node.find(params.require(:id))
  end

  def update
    @node = Node.find(node_params[:id])
    @node.update(node_params)

    if @node.save then
      redirect_to page_url(@node.path), notice: "Node '#{@node.title}' updated"
    else
      flash[:alert] = "Oh no...."
      redirect_to page_url(@node.path)
    end
  end

  private
    def node_params
      params.require(:node).permit(:id, :title, :content, :folder_id)
    end
end
