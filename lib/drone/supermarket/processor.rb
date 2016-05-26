require "mixlib/shellout"

module Drone
  class Commands
    #
    # Class for uploading cookbooks to a Chef Supermarket
    #
    class Processor
      attr_accessor :config

      #
      # Initialize an instance
      #
      def initialize(config)
        self.config = config

        yield(
          self
        ) if block_given?
      end

      #
      # Write required config files
      #
      def configure!
        config.configure!
      end

      #
      # Upload the cookbook to a Chef Supermarket
      #
      def run!
        run_commands
      end

      protected

      def run_commands
        config.commands.each do |cmd|
          execute cmd
        end
      end

      #
      # Upload any roles, environments and data_bags
      #
      def execute(command)
        log.info "- #{command}"

        cmd = Mixlib::ShellOut.new(command)
        cmd.run_command

        log.info cmd.stdout
        if cmd.error?
          log.error cmd.stderr
          raise "Failed while running '#{command}'"
        end
      end

      def log
        config.logger
      end
    end
  end
end
