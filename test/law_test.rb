require 'test_helper'

class LawTest < ActiveSupport::TestCase
  
  def setup
    @law = Robotnik::Authorization::Law.new
  end
  
  test "it has rules" do
    rules = @law.send :rules
    assert_instance_of ActiveSupport::HashWithIndifferentAccess, rules
  end
  
  test "it initiates rules for role" do
    @law.send :init_role_for, :role
    rules = @law.instance_variable_get('@rules')
    assert rules.has_key? :role
    assert_instance_of Robotnik::Authorization::Status, rules[:role]
  end
  
  test "it yields status for authorization definition" do
    @law.status :admin do
      can :read, :book
    end
    assert @law.instance_variable_get('@rules')[:admin].can? :read, :book, nil
  end
  
  test "it has statuses" do
    @law.status :admin do
    end
    assert_equal [:admin], @law.statuses
  end
  
  test "it tests status on given object" do
    object = Object.new
    class << object
      def admin
        true
      end
      def not_admin
        false    
      end
    end
    @law.status :admin do
      can :read, :book
    end
    @law.status :not_admin do
      cannot :read, :book
    end
    assert @law.can? object, :read, :book, nil
    class << object
      def admin
        false
      end
      def not_admin
        true    
      end
    end
    refute @law.can? object, :read, :book, nil
  end
  
  test "it returns false if no status returns true" do
    object = Object.new
    class << object
      def admin
        false
      end
    end
    @law.status :admin do
    end
    refute @law.can? object, :do, :something, nil
  end
  
  test "it defines a new law at class level" do
    Robotnik::Authorization::Law.define do
      status :admin do
      end
    end
    assert_equal [:admin], Robotnik::Authorization::Law.law.statuses
  end
  
  test "it parses all stauses" do
    object = Object.new
    class << object
      def is_a_a
        true
      end
      def is_a_b
        true
      end
    end
    @law.status :is_a_a do
      can :read, :post
    end
    @law.status :is_a_b do
      cannot :read, :post
    end
    refute @law.can? object, :read, :post, nil
  end
  
  test "it accepts defaults" do
    @law.default do
      can :read, :post
    end
    assert @law.can? Object.new, :read, :post, nil
  end

end
