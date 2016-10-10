class PagesController < ApplicationController
  def show
    # find a path..
    path = 'root/' + params.require(:path)
    folder = Folder.all.detect { |dir| dir.path == path }

    if folder
      redirect_to folder, notice: "Folder located"
    else
      node = Node.all.detect { |file| file.folder.path + '/' + file.title == path }
      if node
        redirect_to node, notice: "Node found"
      else
        render not_found
      end
    end
  end
end
