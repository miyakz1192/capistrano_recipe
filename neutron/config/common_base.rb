require "logger"

$logger = nil

def logger
  unless $logger
    $logger = Logger.new("log.txt")
  end
  $logger
end

def delete_default_task
  logger.info "DELETE DEFAULT TASK"
  framework_tasks = [:starting, :started, :updating, :updated, :publishing, :published, :finishing, :finished]
  framework_tasks.each do |t|
      Rake::Task["deploy:#{t}"].clear
  end
  Rake::Task[:deploy].clear
  logger.info "DELETE DEFAULT TASK DONE."
end
