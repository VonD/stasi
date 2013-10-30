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
        
        def can? action, resource, options={}
          verdict = false
          rules.each do |rule_condition, actions|
            if Robotnik::Authorization::Status.matches? rule_condition, resource, options
              action_condition = actions[action]
              verdict = case action_condition
                when true, false then action_condition
                else
                  if action_condition.respond_to?(:call)
                    action_condition.call(resource)
                  else
                    deliberation = true
                    deliberation = deliberation && action_condition[:if].call(resource) if action_condition.has_key?(:if)
                    deliberation = deliberation && (! action_condition[:unless].call(resource)) if deliberation && action_condition.has_key?(:unless)
                    deliberation
                  end
              end
            end
          end
          verdict
        end
        
        def self.matches? rule_condition, resource, options
          rule_condition = rule_condition.to_proc if rule_condition.respond_to?(:to_proc)
          begin
            rule_condition === resource
          rescue ArgumentError
            rule_condition.call(resource, options[:agent])
          end
        end
        
      private
        
        def rules
          @rules ||= {}
        end
        
        def init_rule_for resource
          rules[resource] ||= {}
        end
        
    end
  end
end
