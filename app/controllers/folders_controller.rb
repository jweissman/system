class FoldersController < ApplicationController
  include Navigation

  def index
    redirect_to Folder.root
  end

  def show
    @folder = Folder.find(params.require(:id))
  end

  def new
    parent = Folder.find(folder_params[:parent_id])
    @folder = Folder.new(parent: parent)
  end

  def create
    @folder = Folder.new(folder_params.merge(user: current_user))
    if @folder.save then
      redirect_to (@folder), notice: "folder #{@folder.title} created"
    else
      flash[:alert] = @folder.errors.full_messages
      redirect_to folders_path
    end
  end

  def destroy
    @folder = Folder.find(params[:id])
    raise "Cannot delete root" if @folder.title == "/"

    parent = @folder.parent
    if @folder.destroy then
      redirect_to parent, notice: "folder #{@folder.title} destroyed"
    else
      flash[:alert] = @folder.errors.full_messages
      redirect_to @folder
    end
  end

  private
    def folder_params
      params.require(:folder).permit(:title, :parent_id)
    end
end
