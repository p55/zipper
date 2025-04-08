# frozen_string_literal: true

class Service
  def self.call(*args, **kwargs, &block)
    new.call(*args, **kwargs, &block)
  end
end
