namespace :line do
  task alarm: :environment do
    AlarmService.new.run
  end
end
  
namespace :beauty do # 08:00
  task beauty: :environment do
    AlarmService.new.ptt('Beauty', 'NBA')
  end
end

namespace :gossiping do # 11:00
  task gossiping: :environment do
    AlarmService.new.ptt('Gossiping', 'stock')
  end
end

namespace :home do # 14:00
  task home: :environment do
    AlarmService.new.ptt('home-sale', 'car')
  end
end

namespace :marvel do # 16:00
  task marvel: :environment do
    AlarmService.new.ptt('Marvel', 'Boy-Girl')
  end
end

namespace :sex do # 17:00
  task sex: :environment do
    AlarmService.new.ptt('sex', 'japanavgirls')
  end
end

# ==============================================

namespace :japan_Lai do #
  task japan: :environment do
    AlarmService.new.ptt_Lai('Japan_Travel')
  end
end

namespace :marvel_Lai do # 11:30
  task marvel: :environment do
    AlarmService.new.ptt_Lai('marvel', 'Japan_Travel')
  end
end

namespace :stupid_Lai do #
  task stupid: :environment do
    AlarmService.new.ptt_Lai('StupidClown')
  end
end

namespace :happy_Lai do # Birthday
  task happy: :environment do
    AlarmService.new.happy
  end
end