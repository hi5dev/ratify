# Provides permissions to any object that it is included in.
#
# @example Basic usage
#   class User
#     attr_accessor :role
#   end
#
#   class Record
#     include Ratify
#
#     permit User, :create, if: -> { role == :admin }
#   end
#
#   user = User.new
#   Record.permit?(user, :create) # => false
#
#   user.role = :admin
#   Record.permit?(user, :create) # => true
module Ratify
  autoload :Permission, 'ratify/permission'
  autoload :VERSION, 'ratify/version'

  # The methods in this module are added to the object's class methods when
  # {Ratify} is included.
  module ClassMethods
    # All of the permissions for the object.
    #
    # @return [Array<Permission>] List of permissions.
    def permissions
      @permissions ||= []
    end

    # Creates a new permission for the object.
    #
    # @example Basic usage
    #   include Ratify
    #   permit User, :create, :read, :update, :destroy, if: :admin?
    #
    # @return [Array<Permission>] All of the permissions after they're updated.
    def permit(object, *actions, **conditions)
      permissions << Permission.new(object, *actions, **conditions)
    end

    # Checks if the given object is allowed to perform the requested action(s).
    #
    # @param [Object] object The object requesting the action(s).
    # @param [*Symbol] actions The action(s) being requested.
    # @param [Object] scope The scope of permissible object.
    # @return [true | false] Whether or not the object is permitted.
    def permits?(object, *actions, scope: nil)
      permissions.any? { |m| m.permits?(object, *actions, scope: scope) }
    end
  end

  # Called when the object is included in a class.
  #
  # @!visibility private
  # @param [Class] klass The class {Ratify} is being included in.
  # @return [void]
  def self.included(klass)
    klass.extend(Ratify::ClassMethods)
  end

  # Checks the permissions on an instance level.
  #
  # @param [Object] object The object requesting the action(s).
  # @param [*Symbol] actions The actions being requested.
  # @return [true | false] Whether or not the obejct is permitted.
  def permits?(object, *actions)
    self.class.permits?(object, *actions, scope: self)
  end
end
