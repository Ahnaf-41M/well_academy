require "rufus-scheduler"

if defined?(Rails::Server)
  scheduler = Rufus::Scheduler.new

  # Scheduler for cleaning unnecessary blob records from the 'active_storage_blobs' table. The task runs in every 12 hour
  scheduler.every "12h" do
    Rails.logger.info "Running cleanup of orphaned blobs at #{Time.now}"
    begin
      ActiveStorage::Blob.unattached.each(&:purge)
      Rails.logger.info "Orphaned blobs have been cleaned up successfully."
    rescue => e
      Rails.logger.error "Error during blob cleanup: #{e.message}"
    end
  end
end
