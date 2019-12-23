namespace :line do
  task alarm: :environment do
    AlarmService.new.run
  end
end
  
namespace :beauty do # 08:00
  task beauty: :environment do
    AlarmService.new.ptt('Beauty')
  end
end

namespace :lol do # 09:00
  task lol: :environment do
    AlarmService.new.ptt('LoL')
  end
end
 
namespace :home do # 10:00
  task home: :environment do
    AlarmService.new.ptt('home-sale')
  end
end

namespace :gossiping do # 11:00
  task gossiping: :environment do
    AlarmService.new.ptt('Gossiping')
  end
end
 
namespace :stock do # 12:00
  task stock: :environment do
    AlarmService.new.ptt('Stock')
  end
end

namespace :nba do # 13:00
  task nba: :environment do
    AlarmService.new.ptt('NBA')
  end
end

namespace :bg do # 14:00
  task bg: :environment do
    AlarmService.new.ptt('Boy-Girl')
  end
end

namespace :av do # 15:00
  task av: :environment do
    AlarmService.new.ptt('japanavgirls')
  end
end

namespace :sex do # 16:00
  task sex: :environment do
    AlarmService.new.ptt('sex')
  end
end
  
namespace :marvel do # 17:00
  task marvel: :environment do
    AlarmService.new.ptt('Marvel')
  end
end

# ==============================================

namespace :japan_Lai do # 09:00
  task japan: :environment do
    AlarmService.new.ptt_Lai('Japan_Travel')
  end
end

namespace :marvel_Lai do # 11:00
  task marvel: :environment do
    AlarmService.new.ptt_Lai('marvel')
  end
end

namespace :stupid_Lai do # 13:00
  task stupid: :environment do
    AlarmService.new.ptt_Lai('StupidClown')
  end
end

namespace :happy_Lai do # Birthday
  task happy: :environment do
    AlarmService.new.happy
  end
end