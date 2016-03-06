def def_method(name)
  return if methods.detect{|m| m == name}
  puts "define #{name}"
  define_method name do 
    puts "#{name} called"
    roles(name)
  end
end

def validate_version(&block)
  logger = Logger.new("logs.txt")

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

