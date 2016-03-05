require "logger"
#require "version_validation"
#require "/root/capistrano/neutron/config/version_validation.rb"
require_relative "version_validation"

framework_tasks = [:starting, :started, :updating, :updated, :publishing, :published, :finishing, :finished]
framework_tasks.each do |t|
    Rake::Task["deploy:#{t}"].clear
end
Rake::Task[:deploy].clear

puts "GO task"

task :deploy do
  puts "in deploy"
  validate_version do
    puts "IN validate_vertion block"
    puts neutron1.inspect
    puts "IN validate_vertion block"
    puts neutron2.inspect
    puts "IN validate_vertion block"
    puts neutrons.inspect
#    neutrons.current_ver("1.0")
    neutrons.depends_on(neutrons, :later_ver => "3.0")
  end
end



