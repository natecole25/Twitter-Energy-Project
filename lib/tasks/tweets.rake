namespace :tweets do
  desc "TODO"
  task delete_10_days_old: :environment do
    Tweet.where(['created_at < ?', 10.days.ago]).destroy_all
  end

end
