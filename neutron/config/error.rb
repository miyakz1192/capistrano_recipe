
class VersionCheckError < StandardError
  def initialize(source_nodes, target_nodes, expect, node_ver)
    @source_nodes = source_nodes
    @target_nodes = target_nodes

    unless source_nodes.is_a?(Array)
      @source_nodes = [source_nodes]
    end
    unless target_nodes.is_a?(Array)
      @target_nodes = [target_nodes]
    end

    @expect       = expect
    @node_ver     = node_ver
    @equal_sign   = nil
  end

  def message
    if @target_nodes.empty?
      source = @source_nodes.map{|s| s.roles.to_a}.flatten.uniq
      "version error. source(#{source}). expect: #{@expect} #{@equal_sign} actual: #{@node_ver}"
    else
      source = @source_nodes.map{|s| s.roles.to_a}.flatten.uniq
      target = @target_nodes.map{|s| s.roles.to_a}.flatten.uniq
      "version error. source(#{source}) and taget(#{target}). target version invalid. expect: #{@node_ver} expect: #{@expect} #{@equal_sign} actual: #{@node_ver}"
    end
    
  end
end

class VersionCheckErrorLater < VersionCheckError 
  def initialize(source_nodes, target_nodes, expect, node_ver)
    super(source_nodes, target_nodes, expect, node_ver)
    @equal_sign = "<="
  end
end

class VersionCheckErrorJust < VersionCheckError 
  def initialize(source_nodes, target_nodes, expect, node_ver)
    super(source_nodes, target_nodes, expect, node_ver)
    @equal_sign = "=="
  end
end

class VersionCheckErrorPrevious < VersionCheckError 
  def initialize(source_nodes, target_nodes, expect, node_ver)
    super(source_nodes, target_nodes, expect, node_ver)
    @equal_sign = ">"
  end
end
