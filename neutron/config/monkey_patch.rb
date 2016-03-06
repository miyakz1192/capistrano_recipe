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
    node_ver = version

    if expect[:just_ver]
      unless expect[:just_ver] == node_ver
        expect = expect[:just_ver]
        raise VersionCheckErrorJust.new(self, [], 
                                        expect, node_ver)
      end
    elsif expect[:later_ver]
      unless expect[:later_ver] <= node_ver
        expect = expect[:later_ver]
        raise VersionCheckErrorLater.new(self, [],
                                         expect, node_ver)
      end
    elsif expect[:previous_ver]
      unless expect[:previous_ver] > node_ver
        expect = expect[:previous_ver]
        raise VersionCheckErrorPrevious.new(self, [],
                                            expect, node_ver)
      end
    else
      raise "unknown error"
    end
  end
end
