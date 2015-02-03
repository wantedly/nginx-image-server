require "infrataster/rspec"

Infrataster::Server.define(
  :target,
  ENV["TARGET_IP"],
  vagrant: false,
)
