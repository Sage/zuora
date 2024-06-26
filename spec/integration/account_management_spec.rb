require 'spec_helper'

describe "Account Management", type: :integration do

  describe "given an account" do

    before :each do
      authenticate!
      @account = FactoryBot.create(:account, :account_number => generate_key)
    end

    after :each do
      @account.destroy
    end

    describe "adding and manipulating contacts" do
      it "is supported" do
        contact = FactoryBot.create(:contact, :account => @account, :country => "GB")
        @account.bill_to = contact
        @account.sold_to = contact
        @account.save.should == true
        @account.status = "Active"
        contact.save.should == true
        @account.contacts.size.should == 1
      end
    end

    describe "supported payment methods" do
      it "includes credit cards" do
        FactoryBot.create(:payment_method_credit_card, :account => @account)
      end

      it "includes ACH" do
        FactoryBot.create(:payment_method_ach, :account => @account)
      end

      it "includes PayPal" do
        # TODO: This cannot work unless Zuora is set up with proper paypal configs.
        # FactoryBot.create(:payment_method_paypal, :account => @account)
      end
    end
  end

  describe "an active account fixture" do
    it "can be destroyed" do
      account = FactoryBot.create(:active_account, :account_number => generate_key)
      account.status.should == 'Active'
      account.destroy.should == true
    end
  end
end
