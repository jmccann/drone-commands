require "spec_helper"
require "drone"

describe Drone::Commands::Config do
  include FakeFS::SpecHelpers

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

  let(:file) { double("File") }

  let(:payload) do
    p = Drone::Plugin.new build_data.to_json
    p.parse
    p.result
  end

  let(:config) do
    Drone::Commands::Config.new payload
  end

  before do
    allow(Dir).to receive(:home).and_return "/root"
  end

  describe '#validate!' do
    it "does not throw an error if validation passes" do
      expect { config.validate! }.not_to raise_error
    end
  end

  describe '#configure!' do
    it "writes .netrc file" do
      allow(config).to receive(:write_keyfile)

      expect(File).to receive(:open).with("/root/.netrc", "w").and_yield(file)
      expect(file).to receive(:puts).with("machine the_machine")
      expect(file).to receive(:puts).with("  login johndoe")
      expect(file).to receive(:puts).with("  password test123")

      config.configure!
    end

    it "does not write .netrc file on local build" do
      build_data["workspace"].delete "netrc"

      allow(config).to receive(:write_keyfile)

      expect(File).not_to receive(:open).with("/root/.netrc", "w")

      config.configure!
    end
  end
end
