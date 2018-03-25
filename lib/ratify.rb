module Ratify
  autoload :Permission, 'ratify/permission'
  autoload :VERSION, 'ratify/version'

  module ClassMethods
    def permissions
      @permissions ||= []
    end

    def permit(object, *actions, **conditions)
      permissions << Permission.new(object, *actions, **conditions)
    end

    def permitted?(object, *actions)
      permissions.any? {|permission| permission.permitted?(object, *actions) }
    end
  end

  def self.included(klass)
    klass.extend(Ratify::ClassMethods)
  end
end
