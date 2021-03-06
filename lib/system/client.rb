require "net/http"
require "uri"

require "caches/ttl"

module System
  module API
    class RemoteFolder
      attr_reader :title
      def initialize(hostname, title:, parent_path:)
        @hostname = hostname
        @title = title
        @parent_path = parent_path
      end

      def path
        @parent_path + '/' + title
      end

      def nodes
        p [ :remote_folder_nodes, path: path, host: @hostname ]
        System.client(hostname: @hostname).files(path)
      end

      def children
        p [ :remote_folder_children, path: path, host: @hostname ]
        System.client(hostname: @hostname).folders(path)
      end
    end

    class RemoteFile
      attr_reader :title, :content, :created_at, :updated_at
      def initialize(hostname,
                     title:,
                     content:,
                     parent_path:,
                     created_at:,
                     updated_at:,
                     user_name:,
                     user_email:)

        @hostname = hostname
        @title = title
        @content = content
        @parent_path = parent_path

        @user_name = user_name
        @user_email = user_email
        @created_at = Time.parse(created_at)
        @updated_at = Time.parse(updated_at)
      end

      def user
        @user ||= System::API::User.new(name: @user_name, email: @user_email, host: @hostname)
      end
    end

    class User
      attr_reader :name, :email, :host
      def initialize(name:,email:,host:)
        @name = name
        @email = email
        @host = host
      end
    end

    class Client
      attr_reader :host

      def initialize(hostname, port: 80)
        @host = hostname
        @uri = URI.parse("http://#{hostname}:#{port}")
      end

      def http
        @http ||= Net::HTTP.new(@uri.host, @uri.port)
      end

      def files(path="/")
        #@@files ||= {}
        files_cache[path] ||= list_files(path)
        # @files[path] ||= list_files(path)
      end

      def files_cache
        @files_cache ||= Caches::TTL.new(ttl: 0.5)
      end

      def list_files(path)
        response = http.get(path + "/nodes")
        p [ :response, response ]
        case response.code.to_i
        when 200 || 201
          p [:success]
          files_data = JSON.parse(response.body)
          files_data.map do |remote_attrs|
            RemoteFile.new(
              self.host,
              title: remote_attrs["title"],
              content: remote_attrs["content"],
              parent_path: path,
              created_at: remote_attrs["created_at"],
              updated_at: remote_attrs["updated_at"],
              user_name: remote_attrs["user"]["name"],
              user_email: remote_attrs["user"]["email"]
            )
          end
        when (400..499)
          p [:bad_request]
          []
        when (500..599)
          p [:server_problems]
          []
        end
      end

      def folders(path="/")
        folders_cache[path] ||= list_folders(path)
        # @folders ||= {}
        # @folders[path] ||= list_folders(path)
      end

      def folders_cache
        @folders_cache ||= Caches::TTL.new(ttl: 0.5)
      end

      def list_folders(path)
        p [ :uri, @uri ]
        # list all remote folders...
        response = http.get(path + "/folders")
        p  [ :response, response ]

        case response.code.to_i
        when 200 || 201
          p [:success]
          folders_data = JSON.parse(response.body)
          folders_data.map do |remote_folder_attrs|
            p [ :create_remote_folder, remote_folder_attrs ]

            RemoteFolder.new(
              self.host,
              title: remote_folder_attrs["title"],
              parent_path: path
            )
          end
        when (400..499)
          p [:bad_request]
          []
        when (500..599)
          p [:server_problems]
          []
        end
      end

    end
  end

  # todo request-local client?
  def self.client(hostname:)
    @clients ||= {}
    @clients[hostname] ||=  API::Client.new(hostname)
  end
end
