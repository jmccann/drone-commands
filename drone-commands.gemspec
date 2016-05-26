Gem::Specification.new do |s|
  s.name = "drone-commands"
  s.version = "0.0.0"
  s.date = Time.now.utc.strftime("%F")

  s.authors = ["Jacob McCann"]
  s.email = ["jmccann.git@gmail.com"]

  s.summary = <<-EOF
    Drone plugin to run commands
  EOF

  s.description = <<-EOF
    Drone plugin to run commands
  EOF

  s.homepage = "https://github.com/jmccann/drone-commands"
  s.license = "Apache-2.0"

  s.files = ["README.md", "LICENSE"]
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("bin/**/drone-*")

  s.test_files = Dir.glob("spec/**/*")

  s.executables = ["drone-commands"]
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 1.9.3"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "yard"
  s.add_development_dependency "fakefs"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-lcov"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "pry"

  # Keep the versions in sync with the Dockerfile
  s.add_runtime_dependency "droneio", "~> 1.0"
  s.add_runtime_dependency "mixlib-shellout", "~> 2.2"
  s.add_runtime_dependency "rspec", "~> 3.4"
  s.add_runtime_dependency "serverspec", "~> 2.36"

  # Needed until coercible has proper dependencies defined
  s.add_runtime_dependency "bigdecimal", "~> 1.2"
end
