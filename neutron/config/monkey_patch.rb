require "logger"
require_relative "error"

logger.info "monkey patch check"

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

logger.info "monkey patch check done"

class Array
  def depends_on(nodes, expect)
    nodes = [nodes] unless nodes.is_a?(Array)
    nodes.current_ver(expect)
  end

  def current_ver(expect)
    self.each do |node|
      node.current_ver(expect)
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

  def current_ver(expect)
    actual_ver = version

    if expect[:equals]
      unless expect[:equals] == actual_ver
        expect = expect[:equals]
        raise VersionCheckErrorEquals.new(self,expect,actual_ver)
      end
    elsif expect[:lower_than]
      unless expect[:lower_than] > actual_ver
        expect = expect[:lower_than]
        raise VersionCheckErrorLowerThan.new(self,expect,actual_ver)
      end
    elsif expect[:bigger_than_equals]
      unless expect[:bigger_than_equals] <= actual_ver
        expect = expect[:bigger_than_equals]
        raise VersionCheckErrorBiggerThanEquals.new(self,
                                                    expect,
                                                    actual_ver)
      end
    else
      raise "unknown error"
    end
  end
end
