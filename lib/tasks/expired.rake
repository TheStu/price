desc "Delete alerts older than a year"
task :delete_old_alerts => :environment do
  Alert.where("created_at < ?", Time.now - 1.year).delete_all
end
