namespace :active_storage do
  desc "Clean up unattached Active Storage blobs"
  task cleanup_unattached: :environment do
    puts "Starting cleanup of unattached Active Storage blobs..."

    unattached_blobs = ActiveStorage::Blob.left_outer_joins(:attachments).where(active_storage_attachments: { id: nil })

    unattached_blobs.find_each do |blob|
      puts "Purging blob: #{blob.filename}"
      blob.purge
    end

    puts "Cleanup complete. #{unattached_blobs.size} blobs purged."
  end
end
