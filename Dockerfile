FROM ruby:2.3

RUN gem install --no-ri --no-rdoc \
      droneio \
      --version '~> 1.0' && \
    gem install --no-ri --no-rdoc \
      mixlib-shellout \
      --version '~> 2.2' && \
    gem install --no-ri --no-rdoc \
      rspec \
      --version '~> 3.4' && \
    gem install --no-ri --no-rdoc \
      serverspec \
      --version '~> 2.36' && \
    gem install --no-ri --no-rdoc \
      bigdecimal \
      --version '~> 1.2'

COPY pkg/drone-commands-0.0.0.gem /tmp/

RUN gem install --no-ri --no-rdoc --local \
  /tmp/drone-commands-0.0.0.gem

# ENTRYPOINT ["/usr/bin/drone-commands"]
ENTRYPOINT ["/usr/local/bundle/bin/drone-commands"]
