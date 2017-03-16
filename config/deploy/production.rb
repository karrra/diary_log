# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "23.83.224.10", user: "deploy", roles: %w{app db web}

set :rails_env, :production
set :pty, true

set :ssh_options, {
  forward_agent: true,
  port: 28662
}
