require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  
  def setup
    @status = Robotnik::Authorization::Status.new
  end

  test "it has rules" do
    rules = @status.send :rules
    assert_instance_of ActiveSupport::HashWithIndifferentAccess, rules
  end
  
  test "it initiates rules for resource" do
    @status.send :init_rule_for, :resource
    rules = @status.instance_variable_get('@rules')
    assert rules.has_key? :resource
    assert_instance_of ActiveSupport::HashWithIndifferentAccess, rules[:resource]
  end
  
  test "it defines prohibition" do
    @status.cannot :read, :book
    refute @status.can? :read, :book, nil
  end
  
  test "it defines strict authorization" do
    @status.can :read, :book
    assert @status.can? :read, :book, nil
  end
  
  test "it defines authorization with if and unless options" do
    assertions = [true, false, false, true, false, true, false, false]
    [[true, nil], [nil, true], [false, nil], [nil, false], [true, true], [true, false], [false, true], [false, false]].each_with_index do |conditions, i|
      conditions_hash = {}
      [:if, :unless].each_with_index do |operator, j|
        unless conditions[j].nil?
          if conditions[j]
            conditions_hash[operator] = Proc.new{ |num| num == 1 }
          else
            conditions_hash[operator] = Proc.new{ |num| num != 1 }
          end
        end
      end
      @status.can :read, :book, conditions_hash
      assert_equal assertions[i], @status.can?(:read, :book, 1)
    end
  end
  
  test "it defines authorizations with a block" do
    @status.can :read, :book do |num|
      num * 2
    end
    assert_equal 6, @status.can?(:read, :book, 3)
  end
  
  test "it defaults to forbidden if permission is not defined" do
    refute @status.can? :be, :free, :nil
  end  

end
