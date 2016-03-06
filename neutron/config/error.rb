
class VersionCheckError < StandardError
  def initialize(source_nodes, target_nodes, expect, node_ver)
    @source_nodes = source_nodes
    @target_nodes = target_nodes
    @expect       = expect
    @node_ver     = node_ver
  end
end

class VersionCheckErrorLater < VersionCheckError 
  def message
    source = @source_nodes.map{|s| s.roles.to_a}.flatten.uniq
    target = @target_nodes.map{|s| s.roles.to_a}.flatten.uniq
    "version error. source(#{source}) and taget(#{target}). target version invalid.  expect: #{@expect} <= actual :#{@node_ver}"
  end
end
