if ENV["RAILS_ENV"] == "production"
  directory "/home/deploy/xserver_transport_fare"
  bind "unix:///home/deploy/xserver_transport_fare/tmp/sockets/puma.sock"
  pidfile "/home/deploy/xserver_transport_fare/tmp/pids/puma.pid"
  state_path "/home/deploy/xserver_transport_fare/tmp/pids/puma.state"
  stdout_redirect "/home/deploy/xserver_transport_fare/log/puma.stdout.log", "/home/deploy/xserver_transport_fare/log/puma.stderr.log", true
else
  port ENV.fetch("PORT") { 3000 }
end

environment ENV.fetch("RAILS_ENV") { "development" }
plugin :tmp_restart
