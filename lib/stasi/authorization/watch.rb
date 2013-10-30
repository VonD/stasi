module Robotnik
  module Authorization
    module Watch
      
      def can? *args
        args[2] ||= {}
        args[2][:agent] = self
        Robotnik::Authorization::Law.law.can? *args
      end
      
    end
  end
end
