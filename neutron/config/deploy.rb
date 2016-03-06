#require "version_validation"
#require "/root/capistrano/neutron/config/version_validation.rb"
require_relative "common_base"
require_relative "error"
require_relative "monkey_patch"
require_relative "version_validation"

logger.info "START"

logger.info "DELETE DEFAULT TASK"
framework_tasks = [:starting, :started, :updating, :updated, :publishing, :published, :finishing, :finished]
framework_tasks.each do |t|
    Rake::Task["deploy:#{t}"].clear
end
Rake::Task[:deploy].clear
logger.info "DELETE DEFAULT TASK DONE."


logger.info "[START] DEPLOY"
task :deploy do
  validate_version do
#    neutrons.current_ver("1.0")
    neutrons.depends_on(neutrons, :later_ver => "3.0")
  end
end
logger.info "[END] DEPLOY"

