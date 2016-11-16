# api client for system???
#
require "net/http"
require "uri"

module System
  module API
    class RemoteFolder
      attr_reader :title
      def initialize(title:, remote_path:)
        # @client = client
        @title = title
        @remote_path = remote_path
      end

      # def path
      #   raise 'do not try to get a local path'
      # end
    end

    class RemoteFile
      attr_reader :title, :content
      def initialize(title:, content:, remote_path:)
        # @client = client
        @title = title
        @content = content
        @remote_path = remote_path
      end
    end

    class Client
      def initialize(host, port: 80)
        @uri = URI.parse("http://#{host}:#{port}")
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
              title: remote_attrs["title"],
              content: remote_attrs["content"],
              parent_path: remote_attrs["parent_path"]
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
              # self,
              title: remote_folder_attrs["title"],
              remote_path: remote_folder_attrs["path"]
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
