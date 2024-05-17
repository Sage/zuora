require 'spec_helper'

describe Zuora::Objects::Subscription do
  it "has a invoice_owner" do
    subject.respond_to?(:invoice_owner=).should be_true
    subject.respond_to?(:invoice_owner).should be_true
  end
end
