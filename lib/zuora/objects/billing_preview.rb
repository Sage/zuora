module Zuora::Objects
  class BillingPreview < Base

    attr_accessor :account_id
    attr_accessor :charge_type_to_exclude
    attr_accessor :target_date
    attr_accessor :including_evergreen_subscription

    validates_presence_of :account_id, :charge_type_to_exclude, :target_date, :including_evergreen_subscription
    def initialise
      @charge_type_to_exclude = 'OneTime'
      @including_evergreen_subscription = true
    end
  end
end
