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

    def permits?(object, *actions, instance: nil)
      permissions.any? { |m| m.permits?(object, *actions, instance: instance) }
    end
  end

  def self.included(klass)
    klass.extend(Ratify::ClassMethods)
  end

  def permits?(object, *actions)
    self.class.permits?(object, *actions, instance: self)
  end
end
