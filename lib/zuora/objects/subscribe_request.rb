module Zuora::Objects
  class SubscribeRequest < Base
    attr_accessor :account
    attr_accessor :subscription
    attr_accessor :bill_to_contact
    attr_accessor :payment_method
    attr_accessor :sold_to_contact
    attr_accessor :product_rate_plan

    store_accessors :subscribe_options
    store_accessors :preview_options

    validate do |request|
      request.must_have_usable(:account)
      request.must_have_usable(:payment_method)
      request.must_have_usable(:bill_to_contact)
      request.must_have_usable(:product_rate_plan)
      request.must_have_new(:subscription)
    end

    # used to validate nested objects
    def must_have_new(ref)
      obj = self.send(ref)
      return errors[ref] << "must be provided" if obj.nil?
      return errors[ref] << "must be new" unless obj.new_record?
      must_have_usable(ref)
    end

    # used to validate nested objects
    def must_have_usable(ref)
      obj = self.send(ref)
      return errors[ref] << "must be provided" if obj.blank?
      obj = obj.is_a?(Array) ? obj : [obj]
      obj.each do |object|
        if object.new_record? || object.changed?
          errors[ref] << "is invalid" unless object.valid?
        end
      end
    end

    # Generate a subscription request
    def create
      # return false unless valid?
      result = connector.subscribe
      apply_response(result.to_hash, :subscribe_response)
    end

    protected

    def apply_response(response_hash, type)
      result = response_hash[type][:result]
      if result[:success]
        subscription.account_id = result[:account_id]
        subscription.id = result[:subscription_id]
        subscription.name = result[:subscription_number]
        subscription.clear_changed_attributes!
        @previously_changed = changes
        clear_changes_information
      else
        self.errors.add(:base, result[:errors][:message])
      end
      return result
    end
    #
    # TODO: Restructute an intermediate class that includes
    # persistence only within ZObject models.
    # These methods are not relevant, but defined in Base
    def find ; end
    def where ; end
    def update ; end
    def destroy ; end
    def save ; end
  end
end

