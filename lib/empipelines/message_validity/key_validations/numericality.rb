require "empipelines/message_validity/key_validation"

module MessageValidity
  class NumericalityValidation < KeyValidation
    def self.proc
      ->(x) { x.respond_to?(:to_int) }
    end

    def self.error_text
      "required keys were not found in message"
    end

    def self.declaration
      :validates_numericality_of_keys
    end
  end
end
