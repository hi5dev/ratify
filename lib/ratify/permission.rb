class Permission
  attr_reader :object, :actions, :conditions

  def initialize(object, *actions, **conditions)
    @object = object
    @actions = actions
    @conditions = conditions
  end

  def permits?(object, *actions, instance: nil)
    object_matches?(object) &&
    action_matches?(actions) &&
    conditions_match?(object, instance, actions)
  end

  private

  def action_matches?(actions)
    actions.all? { |action| self.actions.include?(action) }
  end

  def condition_matches?(name, condition, object, instance, actions)
    match = case condition
    when Proc then instance.instance_exec(object, *actions, &condition)
    when Symbol then instance.send(condition)
    else instance.send(name) == condition
    end

    name == :unless ? !match : match && true
  end

  def conditions_match?(object, instance, actions)
    conditions.empty? || conditions.all? do |name, condition|
      condition_matches?(name, condition, object, instance, actions)
    end
  end

  def object_as_constant
    Object.const_get(object) rescue nil if object.is_a?(String)
  end

  def object_matches?(object)
    self.object === object || object_as_constant === object
  end
end
