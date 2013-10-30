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
      
          attr_reader :statuses
      
          def status method, &block
            init_role_for(method).evaluate &block
          end
          
          def default &block
            status :default, &block
          end
          
          def can? *args
            subject, args = args.shift, args
            verdict = false
            statuses.each do |status|
              if status == :default || status.to_proc.call(subject)
                verdict = rules[status].can? *args
              end
            end
            verdict
          end
          
      private
      
          def rules
            @rules ||= {}.with_indifferent_access
          end
          
          def init_role_for method
            rules[method] ||= begin
              @statuses ||= []
              @statuses << method
              Robotnik::Authorization::Status.new
            end
          end
      
    end
  end
end
