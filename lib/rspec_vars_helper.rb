require "rspec_vars_helper/version"

module RspecVarsHelper
  module ClassMethods
    class VarsDSL
      def initialize(klass)
        @klass = klass
      end

      def method_missing(method_name, *args, &block)
        case method_name
        when /!$/
          @klass.class_eval { let!(:"#{method_name.to_s.sub(/!$/,'')}", &block) }
        else
          @klass.class_eval { let(method_name, &block) }
        end
      end
    end

    def vars(&block)
      VarsDSL.new(self).instance_eval(&block)
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
  end
end
