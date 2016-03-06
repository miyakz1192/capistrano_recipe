require_relative "common_base"
require_relative "error"
require_relative "monkey_patch"
require_relative "version_validation"

delete_default_task

logger.info "[START] DEPLOY"
task :deploy do
  validate_version do
#    neutron1 => 1.0 , neutron2 => 2.0

#    neutrons.current_ver(:lower_than => "2.1") # NOT ERROR OK
#    neutrons.current_ver(:lower_than => "2.0") # ERROR OK
#    neutrons.current_ver(:lower_than => "1.9") # ERROR OK
#    neutrons.current_ver(:lower_than => "1.0") # ERROR OK 
#    neutrons.current_ver(:lower_than => "0.9") # ERROR OK 
    
#    neutrons.current_ver(:bigger_than_equals => "2.1") # ERROR OK
#    neutrons.current_ver(:bigger_than_equals => "2.0") # ERROR OK
#    neutrons.current_ver(:bigger_than_equals => "1.9") # ERROR OK
#    neutrons.current_ver(:bigger_than_equals => "1.0") # NOT ERR OK 
#    neutrons.current_ver(:bigger_than_equals => "0.9") # NOT ERR OK 
    
#    neutrons.current_ver(:equals => "1.0") # ERR OK
#    neutrons.depends_on(neutrons, :later_ver => "2.0")
  end
end
logger.info "[END] DEPLOY"

