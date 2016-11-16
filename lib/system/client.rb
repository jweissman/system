require "net/http"
require "uri"

module System
  module API
    class RemoteFolder
      attr_reader :title
      def initialize(hostname, title:, parent_path:)
        @hostname = hostname
        @title = title
        @parent_path = parent_path
      end

      def children
        []
      end
    end

    class RemoteFile
      attr_reader :title, :content
      def initialize(hostname,title:, content:, parent_path:,user_id:)
        @hostname = hostname
        @title = title
        @content = content
        @parent_path = parent_path
        # @folder_id =
        @remote_user_id = user_id
      end

      def user
        System::API::User.site = @hostname
        System::API::User.find(@remote_user_id)
      end
    end

    class User < ActiveResource::Base
    end

    class Client
      attr_reader :host

      def initialize(hostname, port: 80)
        @host = hostname
        @uri = URI.parse("http://#{hostname}:#{port}")
        # p [ :uri, @uri ]
      end

      def http
        @http ||= Net::HTTP.new(@uri.host, @uri.port)
      end

      def files
        response = http.get("/nodes")
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
              parent_path: "/",
              user_id: remote_attrs["user"]["id"]
              # remote_path: remote_attrs["path"]
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

      def folders
        p [ :uri, @uri ]
        # list all remote folders...
        response = http.get("/folders")
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
              parent_path: "/"
              # remote_path: remote_folder_attrs["path"]
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

  def self.client(hostname:)
    API::Client.new(hostname)
  end
end
