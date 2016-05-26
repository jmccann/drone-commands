require "pathname"
require "logger"

module Drone
  class Commands
    #
    # Chef plugin configuration
    #
    class Config
      extend Forwardable

      attr_accessor :payload, :logger

      delegate [:vargs, :workspace] => :payload,
               [:netrc] => :workspace,
               [:commands] => :vargs

      #
      # Initialize an instance
      #
      def initialize(payload, log = nil)
        self.payload = payload
        self.logger = log || default_logger
      end

      #
      # Write config files to filesystem
      #
      def configure!
        write_netrc
      end

      #
      # Validate that all requirements are met
      #
      # @raise RuntimeError
      #
      def validate!
        raise "No plugin data found" if vargs.empty?

        raise "Please provide command" if commands.nil?
        raise "Please provide Array for command" unless commands.is_a? Array
      end

      protected

      def default_logger
        @logger ||= Logger.new(STDOUT).tap do |l|
          l.level = Logger::INFO
          l.formatter = proc do |sev, datetime, _progname, msg|
            "#{sev}, [#{datetime}] : #{msg}\n"
          end
        end
      end

      #
      # The path to write our netrc config to
      #
      def netrc_path
        @netrc_path ||= Pathname.new(
          Dir.home
        ).join(
          ".netrc"
        )
      end

      #
      # Write a .netrc file
      #
      def write_netrc
        return if netrc.nil?
        netrc_path.open "w" do |f|
          f.puts "machine #{netrc.machine}"
          f.puts "  login #{netrc.login}"
          f.puts "  password #{netrc.password}"
        end
      end
    end
  end
end
