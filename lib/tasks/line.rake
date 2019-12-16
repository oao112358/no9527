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
 
namespace :japan do # 10:00
  task japan: :environment do
    AlarmService.new.ptt('Japan_Travel')
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

namespace :home do # 13:00
  task home: :environment do
    AlarmService.new.ptt('home-sale')
  end
end
  
namespace :bg do # 14:00
  task bg: :environment do
    AlarmService.new.ptt('Boy-Girl')
  end
end

namespace :sex do # 15:00
  task sex: :environment do
    AlarmService.new.ptt('Sex')
  end
end
  
namespace :japanavgirls do # 16:00
  task japanavgirls: :environment do
    AlarmService.new.ptt('japanavgirls')
  end
end

namespace :marvel do # 17:00
  task marvel: :environment do
    AlarmService.new.ptt('Marvel')
  end
end
