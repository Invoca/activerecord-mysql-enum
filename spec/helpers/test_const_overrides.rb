# frozen_string_literal: true

module ConstantOverrides
  module TestConstOverride
    @constant_overrides = []

    class << self
      attr_accessor :constant_overrides
    end

    def setup_constant_overrides
      unless TestConstOverride.constant_overrides.empty?
        warn "Uh-oh! constant_overrides left over: #{TestConstOverride.constant_overrides.inspect}\n#{caller.join("\n")}\n-----------\n"
        cleanup_constant_overrides
      end
    end

    def cleanup_constant_overrides
      TestConstOverride.constant_overrides.reverse.each do |parent_module, k, v|
        ensure_completely_safe "constant cleanup #{k.inspect}, #{parent_module}(#{parent_module.class})::#{v.inspect}(#{v.class})" do
          silence_warnings do
            if v == :never_defined
              parent_module.send(:remove_const, k)
            else
              parent_module.const_set(k, v)
            end
          end
        end
      end
      TestConstOverride.constant_overrides = []
    end

    def unset_test_const(const_name)
      const_name.is_a?(Symbol) and const_name = const_name.to_s
      const_name.is_a?(String) or raise "Pass the constant name, not its value!"

      final_parent_module = final_const_name = nil
      original_value =
          const_name.split('::').reduce(Object) do |parent_module, nested_const_name|
            parent_module == :never_defined and raise "You need to set each parent constant earlier! #{nested_const_name}"
            final_parent_module = parent_module
            final_const_name    = nested_const_name
            parent_module.const_get(nested_const_name) rescue :never_defined
          end

      TestConstOverride.constant_overrides << [final_parent_module, final_const_name, original_value]

      silence_warnings { final_parent_module.send(:remove_const, final_const_name) }
    end

    def set_test_const(const_name, value)
      const_name.is_a?(Symbol) and const_name = const_name.to_s
      const_name.is_a?(String) or raise "Pass the constant name, not its value!"

      final_parent_module = final_const_name = nil
      original_value =
          const_name.split('::').reduce(Object) do |parent_module, nested_const_name|
            parent_module == :never_defined and raise "You need to set each parent constant earlier! #{nested_const_name}"
            final_parent_module = parent_module
            final_const_name    = nested_const_name
            parent_module.const_get(nested_const_name) rescue :never_defined
          end

      TestConstOverride.constant_overrides << [final_parent_module, final_const_name, original_value]

      silence_warnings { final_parent_module.const_set(final_const_name, value) }
    end

    def ensure_completely_safe(exception_context = "", log_context = {})
      yield
    rescue SystemExit, SystemStackError, NoMemoryError, SecurityError, SignalException
      raise
    rescue Exception => ex
      warn(ex, exception_context, **log_context)
      nil
    end
  end
end
