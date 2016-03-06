require "logger"

$logger = nil

def logger
  unless $logger
    $logger = Logger.new("log.txt")
  end
  $logger
end
