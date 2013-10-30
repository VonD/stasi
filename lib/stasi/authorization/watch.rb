module Robotnik
  module Authorization
    module Watch
      
      def can? *args
        Robotnik::Authorization::Law.law.can? *(args.unshift(self))
      end
      
    end
  end
end
