namespace :line do
  task alarm: :environment do
    AlarmService.new.run
  end

end
