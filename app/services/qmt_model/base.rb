# frozen_string_literal: true

module QmtModel
  class Base
    def [](key)
      instance_variable_get("@#{key}")
    end
  end
end
