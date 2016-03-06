
class VersionCheckError < StandardError
  def initialize(source_nodes, expect, actual_ver)
    @source_nodes = source_nodes

    unless source_nodes.is_a?(Array)
      @source_nodes = [source_nodes]
    end

    @expect       = expect
    @actual_ver   = actual_ver
    @equal_sign   = nil
  end

  def message
    source = @source_nodes.map{|s| s.roles.to_a}.flatten.uniq
    "Version error. In nodes(#{source}), version invalid. We expects expect value(#{@expect}) #{@equal_sign} actual value, but actually expect value(#{@expect}) and actual value(#{@actual_ver}), #{@equal_sign} not establishment"
  end
end

class VersionCheckErrorEquals < VersionCheckError 
  def initialize(source_nodes, expect, actual_ver)
    super(source_nodes, expect, actual_ver)
    @equal_sign = "=="
  end
end

class VersionCheckErrorLowerThan < VersionCheckError 
  def initialize(source_nodes, expect, actual_ver)
    super(source_nodes, expect, actual_ver)
    @equal_sign = ">"
  end
end

class VersionCheckErrorBiggerThanEquals < VersionCheckError 
  def initialize(source_nodes, expect, actual_ver)
    super(source_nodes, expect, actual_ver)
    @equal_sign = "<="
  end
end
