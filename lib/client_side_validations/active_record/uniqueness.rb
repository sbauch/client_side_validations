module ClientSideValidations::ActiveRecord
  module Uniqueness
    def client_side_hash(model, attribute)
      hash = {}
      hash[:allow_blank] = options[:allow_blank]
      hash[:allow_nil] = options[:allow_nil]      
      hash[:message] = model.errors.generate_message(attribute, message_type, options.except(:scope))
      hash[:case_sensitive] = options[:case_sensitive]
      hash[:id] = model.id unless model.new_record?
      if options.key?(:scope) && options[:scope].present?
        hash[:scope] = Array.wrap(options[:scope]).inject({}) do |scope_hash, scope_item|
          scope_hash.merge!(scope_item => model.send(scope_item))
        end
      end

      unless model.class.name.demodulize == model.class.name
        hash[:class] = model.class.name.underscore
      end

      hash
    end

    private

    def message_type
      :taken
    end
  end
end

