require "logger"

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
  def depends_on(nodes, condition = {})
    nodes = [nodes] unless nodes.is_a?(Array)

    #TODO: condition variation 
    nodes.each do |node|
      if condition[:later_ver]
        expect = condition[:later_ver] 
        node_ver = node.version
        unless expect <= node_ver
          raise VersionCheckErrorLater.new(self, nodes, 
                                           expect, node_ver)
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
