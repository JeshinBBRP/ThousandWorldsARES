module AresMUSH
  module FS3Combat    
    class DamageCronHandler      
      def on_event(event)
        config = Global.read_config("fs3combat", "healing_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Character.all.each do |c|
          FS3Combat.heal_wounds(c)          
        end
      end
    end
  end
end