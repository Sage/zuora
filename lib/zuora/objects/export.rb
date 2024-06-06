module Zuora::Objects
  class Export < Base
    def download
      connector.download(self)
    end

    def ready?
      self.status == 'Completed'
    end

    define_attributes do
      defaults :format => 'csv'
    end
  end
end
