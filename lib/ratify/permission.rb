class Permission
  attr_reader :object, :actions, :conditions

  def initialize(object, *actions, **conditions)
    @object = object
    @actions = actions
    @conditions = conditions
  end

  def permitted?(object, *actions)
    object_matches?(object) &&
    action_matches?(actions) &&
    conditions_match?(object, actions)
  end

  private

  def action_matches?(actions)
    actions.all? { |action| self.actions.include?(action) }
  end

  def condition_matches?(name, condition, object, actions)
    match = case condition
    when Proc then condition.call(object, *actions)
    when Symbol then object.send(condition) if object.respond_to?(condition)
    else object.send(name) == condition if object.respond_to?(name)
    end

    name == :unless ? !match : match && true
  end

  def conditions_match?(object, actions)
    conditions.empty? || conditions.all? do |name, condition|
      condition_matches?(name, condition, object, actions)
    end
  end

  def object_as_constant
    Object.const_get(object) rescue nil if object.is_a?(String)
  end

  def object_matches?(object)
    self.object === object || object_as_constant === object
  end
end
