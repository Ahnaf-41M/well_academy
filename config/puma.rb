# config/puma.rb

# Maximum number of threads Puma can use per worker process (8 default)
max_threads = ENV.fetch("RAILS_MAX_THREADS", 8)

# Minimum number of threads Puma can use per worker process (5 default)
min_threads = ENV.fetch("RAILS_MIN_THREADS", 5)

# Set Puma’s thread pool to use between min_threads and max_threads.
# Each worker can handle multiple requests concurrently using threads.
threads min_threads, max_threads

# Set the number of Puma worker processes (multi-process model).
# Defaults to 4 (often one worker per CPU core).
workers ENV.fetch("WEB_CONCURRENCY", 4)

# Preload the application before forking worker processes.
# Saves memory using Copy-On-Write and speeds up worker boot times.
preload_app!

# Set the TCP port Puma will listen on.
# Defaults to 3000 if PORT is not provided.
port ENV.fetch("PORT", 3000)

# Set the Rails environment (development, production, etc.).
# Defaults to "development".
environment ENV.fetch("RAILS_ENV", "development")

# Path where Puma will store its process ID (useful for restarting/stopping).
pidfile "tmp/pids/puma.pid"

# Path where Puma will store its internal state (used by tools like pumactl).
state_path "tmp/pids/puma.state"

# Code to run when a new worker boots (after forking).
on_worker_boot do
  # Ensure each worker process establishes its own DB connection.
  # Without this, workers could share stale or broken connections.
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end

# Allow Puma to be restarted by the `rails restart` command.
plugin :tmp_restart
