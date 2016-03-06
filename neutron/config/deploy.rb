require_relative "common_base"
require_relative "error"
require_relative "monkey_patch"
require_relative "version_validation"

delete_default_task

logger.info "[START] DEPLOY"
task :deploy do
  validate_version do
    neutrons.current_ver(:previous_ver => "2.1")
    neutrons.depends_on(neutrons, :later_ver => "2.0")
  end
end
logger.info "[END] DEPLOY"

