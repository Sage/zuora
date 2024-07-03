module Zuora
  class Version
    MAJOR = 2
    MINOR = 0
    PATCH = 3

    def self.to_s
      "#{MAJOR}.#{MINOR}.#{PATCH}"
    end
  end
end
