require "spec_helper"
require "drone"

describe Drone::Commands::Processor do
  let(:build_data) do
    {
      "workspace" => {
        "path" => "/path/to/project",
        "netrc" => {
          "machine" => "the_machine",
          "login" => "johndoe",
          "password" => "test123"
        }
      },
      "vargs" => {
        "commands" => ["ls", "echo 'hi'"]
      }
    }
  end

  let(:payload) do
    p = Drone::Plugin.new build_data.to_json
    p.parse
    p.result
  end

  let(:stringio) do
    StringIO.new
  end

  let(:logger) do
    Logger.new stringio
  end

  let(:config) do
    Drone::Commands::Config.new payload, logger
  end

  let(:processor) do
    Drone::Commands::Processor.new config
  end

  let(:shellout) do
    double("shellout", run_command: nil,
                       stdout: "shellout output",
                       stderr: "shellout error",
                       error?: false)
  end

  before do
    allow(Mixlib::ShellOut).to receive(:new).and_return shellout

    # allow(Mixlib::ShellOut)
    #   .to receive(:new).with(/knife supermarket share/)
    #   .and_return knife_share_shellout
  end

  describe '#configure!' do
    before do
      allow(config).to receive(:configure!)
    end

    it "calls configure from Drone::Supermarket::Config" do
      expect(config).to receive(:configure!)

      processor.configure!
    end
  end

  describe '#run!' do
    it "runs all the commands" do
      expect(Mixlib::ShellOut).to receive(:new).with("ls")
      expect(Mixlib::ShellOut).to receive(:new).with("echo 'hi'")

      processor.run!
    end
  end
end
