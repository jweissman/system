class Path
  def initialize(str)
    @target = str
  end

  def refer
    seek(@target, context: Folder.root)
  end

  # all resources which can be 'immediately' reached from the context
  def contextual_references(ctx)
    ctx.children + ctx.virtual_children + ctx.nodes + ctx.virtual_nodes + ctx.remote_children + ctx.remote_nodes
  end

  def seek(subpath, context:)
    # puts "--- SEEK subpath #{subpath} (context: #{context.path})"
    raise "Path #{subpath} does not begin with '/'" unless subpath.start_with?("/")
    return context if subpath == '/'

    path_without_leading_slash = subpath[1..-1]
    slash_count = path_without_leading_slash.count('/')
    if slash_count == 0
      matching_reference = contextual_references(context).detect do |reference|
        reference.title == path_without_leading_slash
      end

      if matching_reference
        return matching_reference
      end
    else
      subfolder_name, *remaining_path = path_without_leading_slash.split('/')
      matching_subfolder = (context.children + context.virtual_children).detect do |child|
        child.title == subfolder_name
      end

      if matching_subfolder
        new_path = ('/'+remaining_path.join('/'))
        seek new_path, context: matching_subfolder
      end
    end
  end

  class << self
    def decompose(path)
      path_elements = path.split('/')
      return ['/'] if path_elements.count == 0

      path_elements.inject([]) do |(root,*rest), element|
        component = if element.empty?
                      '/'
                    else
                      if rest.any?
                        rest.last + '/' + element
                      else
                        '/' + element
                      end
                    end

        [root].compact + rest + [component]
      end
    end

    def dereference(str)
      # this will cache references that can break (b/c removal...) :/
      # @references ||= {}
      # @references[str] ||=
      new(str).refer
    end

    def analyze(str)
      decompose(str).map do |component|
        dereference component
      end
    end
  end
end
