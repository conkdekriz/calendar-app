# frozen_string_literal: true

class ModelBuilder
  def self.build(hash, name: nil)
    klass_name = name
    id = hash['id']
    attrs = hash
    attrs['id'] = id.to_s
    
    build_klass(klass_name, attrs) unless klass_name.nil?
    klass = klass_name.constantize
    klass.new(attrs)
  end

  def self.class_exists?(klass_name)
    klass = begin
              JsonapiModel.const_get(klass_name)
            rescue StandardError
              nil
            end
    klass.is_a? Class
  end

  # Builds the class and registers it
  # @param klass_name[String] name of the class
  # @param attrs[Hash<Symbol, Object>] Object attributes
  # @return nil
  def self.build_klass(klass_name, attrs)
    Rails.logger.debug "Building class #{klass_name}"
    attr_keys = attrs.keys
    klass = Class.new(JsonapiModel) do
      attr_keys.each { |k| attr_accessor k }
    end
    Object.const_set klass_name, klass
    nil
  end
end
