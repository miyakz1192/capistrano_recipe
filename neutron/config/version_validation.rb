
require "pp"

class VersionCheckError < StandardError

end

puts "monkey patch check"
targets = [[Array,
           ["depends_on"]],

           [Capistrano::Configuration::Server,
           ["depends_on", "version"]],]

targets.each do |cls, method_names|
  method_names.each do |meth|
    if cls.instance_methods.detect{|m| m == meth}
      puts "FAITAL: already defined #{meth} in #{cls}"
      exit 1
    end
  end
end
puts "monkey patch check done"

class Array
  def depends_on(nodes, condition = {})
    #TODO: condition check
    puts "=> depends_on"
    self.each do |node|
      puts node.inspect
      puts node.version.inspect
      if condition[:later_ver]
        unless condition[:later_ver] <= node.version
          puts "version check errror"

        end
      end
    end
  end
end

class Capistrano::Configuration::Server
  def version
    res = nil 
    on self do
      res = capture "cat /home/miyakz/version"
    end
    res
  end
end

def def_method(name)
  return if methods.detect{|m| m == name}
  puts "define #{name}"
  define_method name do 
    puts "#{name} called"
    roles(name)
  end
end

def validate_version(&block)
  logger = Logger.new("res_log.txt")

  puts "start validation version"
  pp roles(:all)

  roles(:all).each do |node|
    role_multi  = node.roles.to_a.select{|r| r =~ /.*s$/}
    role_single = node.roles.to_a.reject{|r| r =~ /.*s$/}

    if role_multi.size > 1 || role_single.size > 1
      hostname = node.hostname
      logger.error "#{hostname} invalid roles #{role_single.inspect}"
      logger.error "#{hostname} invalid roles #{role_multi.inspect}"
      next
    end

    unless role_multi.empty?
      role = role_multi[0]
      def_method(role)
    end

    unless role_single.empty?
      role = role_single[0]
      def_method(role)
    end
  end

  block.call
end

