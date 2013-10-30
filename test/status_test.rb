require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  
  Book = Class.new
  
  def setup
    @status = Robotnik::Authorization::Status.new
  end

  test "it has rules" do
    rules = @status.send :rules
    assert_instance_of Hash, rules
  end
  
  test "it initiates rules for resource" do
    @status.send :init_rule_for, :resource
    rules = @status.instance_variable_get('@rules')
    assert rules.has_key? :resource
    assert_instance_of Hash, rules[:resource]
  end
  
  test "it defines prohibition" do
    @status.cannot :read, Book
    refute @status.can? :read, Book.new
    assert_equal false, @status.instance_variable_get('@rules')[Book][:read]
  end
  
  test "it defines strict authorization" do
    @status.can :read, Book
    assert @status.can? :read, Book.new
    assert_equal true, @status.instance_variable_get('@rules')[Book][:read]
  end
  
  test "it defines authorization with if and unless options" do
    Post = Struct.new :name
    assertions = [true, false, false, true, false, true, false, false]
    [[true, nil], [nil, true], [false, nil], [nil, false], [true, true], [true, false], [false, true], [false, false]].each_with_index do |conditions, i|
      conditions_hash = {}
      [:if, :unless].each_with_index do |operator, j|
        unless conditions[j].nil?
          if conditions[j]
            conditions_hash[operator] = Proc.new{ |post| post.name == 'test' }
          else
            conditions_hash[operator] = Proc.new{ |post| post.name != 'test' }
          end
        end
      end
      @status.can :read, Post, conditions_hash
      assert_equal assertions[i], @status.can?(:read, Post.new('test'))
    end
  end
  
  test "it defines authorizations with a block" do
    Book.class_eval do
      attr_accessor :collection
      def self.all
        Book.new.tap do |book|
          book.collection = [1, 2, 3, 4]
        end
      end
    end
    @status.can :read, Book do |books|
      books.collection.first 2
    end
    assert_equal [1, 2], @status.can?(:read, Book.all)
  end
  
  test "it defaults to forbidden if permission is not defined" do
    refute @status.can? :be, :free
  end
  
  test "it accepts a class" do
    @status.can :read, Object
    assert @status.can? :read, Object.new
    assert @status.can? :read, Object
  end
  
  test "it accepts a symbol as a method name" do
    o = Object.new
    class << o
      def taggable
        true
      end
    end
    @status.can :read, :taggable
    assert @status.can? :read, o
  end
  
  test "it accepts a symbol for a method with one argument and evaluates it with the agent" do
    o = Object.new
    class << o
      def taggable user
        user[:name] == 'test'
      end
    end
    @status.can :read, :taggable
    assert @status.can? :read, o, {agent: {name: 'test'}}
    refute @status.can? :read, o, {agent: {name: 'tested'}}
  end
  
  test "the last matching condition is returned" do
    o = Object.new
    class << o
      def taggable
        true
      end
    end
    @status.cannot :read, Object
    @status.can :read, :taggable
    assert @status.can? :read, o
  end
  
  test "it overrides the matching condition when :as option is present" do
    @status.can :read, Fixnum
    refute @status.can? :read, Object.new
    assert @status.can? :read, Object.new, as: Fixnum
  end

end
