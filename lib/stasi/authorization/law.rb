module Robotnik
  module Authorization
    class Law
      
      #--- Class methods ---#
      
          include Robotnik::DslEval
          
          cattr_reader :law
      
          def self.define &block
            @@law = self.new.evaluate(&block)
          end
          
          def self.reset!
            @@law = nil
          end
          
      #--- Instance methods ---#
      
          def status method, &block
            init_role_for(method).evaluate &block
          end
          
          def statuses
            rules.keys
          end
          
          def can? *args
            subject, args = args.shift, args
            verdict = false
            statuses.each do |status|
              if subject.send status
                verdict = rules[status].can? *args
                break
              end
            end
            verdict
          end
          
      private
      
          def rules
            @rules ||= {}.with_indifferent_access
          end
          
          def init_role_for method
            rules[method] ||= Robotnik::Authorization::Status.new
          end
      
    end
  end
end
