require 'test_helper'

class WatchTest < ActiveSupport::TestCase

  test "calls the law class can? with self as first arg" do
    object = Object.new
    object.extend Robotnik::Authorization::Watch
    class << object
      def admin
        true
      end
    end
    Robotnik::Authorization::Law.define do
      status :admin do
        can :do, :something
      end
    end
    assert object.can?(:do, :something, :stupid)
  end
  
end
