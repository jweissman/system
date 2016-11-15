class VirtualFoldersController < ApplicationController
  def show
    Rails.logger.info "vfolder params: #{virtual_folder_params}"

    @virtual_folder = VirtualFolder.new(
      title: virtual_folder_params[:title],
      parent_path: virtual_folder_params[:parent_path]
    )

    @path_components = Path.analyze(@virtual_folder.path)
  end

  private
    def virtual_folder_params
      params.permit(:title, :parent_path)
    end
end
