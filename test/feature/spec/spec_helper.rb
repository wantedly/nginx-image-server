require "infrataster/rspec"
require "dotenv"

Dotenv.load

Infrataster::Server.define(
  :target,
  ENV["TARGET_IP"],
  vagrant: false,
)
