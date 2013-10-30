module Robotnik
  module Authorization
    class Law
      
      #--- Class methods ---#
      
          include Robotnik::DslEval
      
          def self.define &block
            @@law = self.new.evaluate(&block)
          end
          
          def self.reset!
            @@law = nil
          end
          
          def self.law
            @@law
          end
          
      #--- Instance methods ---#
      
          attr_reader :statuses
          
          def initialize
            @statuses = []
          end
      
          def status method, &block
            init_role_for(method).evaluate &block
          end
          
          def default &block
            status :default, &block
          end
          
          def can? action, resource, options
            verdict = false
            statuses.each do |status|
              if status == :default || status.to_proc.call(options[:agent])
                verdict = rules[status].can? action.to_sym, resource, options
              end
            end
            verdict
          end
          
      private
      
          def rules
            @rules ||= {}
          end
          
          def init_role_for method
            rules[method] ||= begin
              @statuses << method
              Robotnik::Authorization::Status.new
            end
          end
      
    end
  end
end
