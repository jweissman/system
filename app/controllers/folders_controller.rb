class FoldersController < ApplicationController
  def index
    # root
    @root = Folder.find_by(parent: nil)
    redirect_to @root
  end

  def show
    @folder = Folder.find(params.require(:id)) #[:id])
  end

  def new
    parent = Folder.find(folder_params[:parent_id])
    @folder = Folder.new(parent: parent)
  end

  def create
    @folder = Folder.new(folder_params)
    if @folder.save then
      redirect_to folder_path(@folder), notice: "folder #{@folder.title} created"
    else
      flash[:alert] = "Too bad..."
      redirect_to folders_path
    end
  end


  private
    def folder_params
      params.require(:folder).permit(:title, :parent_id)
    end
end
