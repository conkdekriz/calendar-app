# frozen_string_literal: true

# Gives some ActiveModel functionality to objects loaded from the API
class JsonapiModel
  include ActiveModel::Model

  attr_accessor :id

  def initialize(attrs)
    attrs.each do |name, value|
      instance_variable_set("@#{name}", value)
    end
  end

  def cache_key
    "#{self.class}-#{id}-#{DateTime.parse(@updated_at).to_i}"
  end
end
