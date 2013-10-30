module Robotnik
  module Authorization
    class Status
      
      include Robotnik::DslEval
        
        def can action, resource, conditions=nil, &block
          init_rule_for resource
          rules[resource][action] = conditions || block || true
        end
        
        def cannot action, resource
          init_rule_for resource
          rules[resource][action] = false
        end
        
        def can? action, resource, subject
          begin
            condition = rules[resource][action]
            case condition
              when true, false then condition
              else
                return condition.call(subject) if condition.respond_to?(:call)
                deliberation = true
                deliberation = deliberation && condition[:if].call(subject) if condition.has_key?(:if)
                deliberation = deliberation && (! condition[:unless].call(subject)) if deliberation && condition.has_key?(:unless)
                deliberation
            end
          rescue NoMethodError
            false
          end
        end
        
      private
        
        def rules
          @rules ||= {}.with_indifferent_access
        end
        
        def init_rule_for resource
          rules[resource] ||= {}.with_indifferent_access
        end
        
    end
  end
end
