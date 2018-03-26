# @!visibility private
class Permission
  attr_reader :object, :actions, :conditions

  # @param [Object] object
  # @param [*Symbol] actions
  # @param [**Hash] conditions
  # @return [Permission] New instance of {Permission}.
  def initialize(object, *actions, **conditions)
    @object = object
    @actions = actions
    @conditions = conditions
  end

  # @param [Object] object
  # @param [*Symbol] actions
  # @param [Object] scope
  # @return [true | false] Whether or not the object is permitted.
  def permits?(object, *actions, scope: nil)
    object_matches?(object) &&
    action_matches?(actions) &&
    conditions_match?(object, scope, actions)
  end

  private

  # @param [Array<Symbol>] actions
  # @return [true | false] If the given actions are all in the permission.
  def action_matches?(actions)
    actions.all? { |action| self.actions.include?(action) }
  end

  # @param [Symbol] name
  # @param [Proc | Symbol | Object] condition
  # @param [Object] object
  # @param [Object] scope
  # @param [Array<Symbol>] actions
  # @return [true | false] Whether or not the condition matches the permission.
  def condition_matches?(name, condition, object, scope, actions)
    match = case condition
    when Proc then scope.instance_exec(object, *actions, &condition)
    when Symbol then scope.send(condition)
    else scope.send(name) == condition
    end

    name == :unless ? !match : match && true
  end

  # @param [Object] object
  # @param [Object] scope
  # @param [Array<Symbol>] actions
  # @return [true | false] Whether or not all of the conditions match.
  def conditions_match?(object, scope, actions)
    conditions.empty? || conditions.all? do |name, condition|
      condition_matches?(name, condition, object, scope, actions)
    end
  end

  # @return [Constant] The object as a constant.
  def object_as_constant
    return unless object.is_a?(String) || object.is_a?(Symbol)

    Object.const_get(object) rescue nil
  end

  # @param [Object] object
  # @return [true | false] Whether or not the object matches.
  def object_matches?(object)
    self.object === object || object_as_constant === object
  end
end
