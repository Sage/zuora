# frozen_string_literal: true

require 'spec_helper'

describe Zuora::Objects::PaymentMethod do
  before :each do
    allow_any_instance_of(Zuora::Api).to receive(:session).and_return double(key: 'session_key')
    @account = double(Zuora::Objects::Account, id: 1)
  end

  context 'Type helpers' do
    it 'supports credit_card?' do
      FactoryBot.build(:payment_method_credit_card).should be_credit_card
    end

    it 'supports ach?' do
      FactoryBot.build(:payment_method_ach).should be_ach
    end

    it 'supports paypal?' do
      FactoryBot.build(:payment_method_paypal).should be_paypal
    end

    it 'supports debit_card?' do
      FactoryBot.build(:payment_method_debit_card).should be_debit_card
    end

    it 'supports card?' do
      FactoryBot.build(:payment_method_credit_card).should be_card
      FactoryBot.build(:payment_method_debit_card).should be_card
    end
  end

  context 'write only attributes' do
    ach = FactoryBot.build(:payment_method_ach)
    ach.write_only_attributes.should == [:ach_account_number, :credit_card_number,
      :credit_card_security_code, :gateway_option_data, :skip_validation, :bank_transfer_account_number]
  end

  describe "validations" do
    describe "credit_card_expiration_year" do
      let(:payment_method) {Zuora::Objects::PaymentMethod.new(:type => "CreditCard")}
      it 'does not allow this year' do
        payment_method.credit_card_expiration_year = Time.now.year
        payment_method.valid?
        expect(payment_method.errors[:credit_card_expiration_year]).to include("must be greater than #{Time.now.year}")
      end

      it 'should not allow last year' do
        payment_method.credit_card_expiration_year = (Time.now - 1.year).year
        payment_method.valid?
        expect(payment_method.errors[:credit_card_expiration_year]).to include("must be greater than #{Time.now.year}")
      end

      it 'should allow next year' do
        payment_method.credit_card_expiration_year = (Time.now + 1.year).year
        payment_method.valid?
        expect(payment_method.errors[:credit_card_expiration_year])
          .to_not include("must be greater than #{Time.now.year}")
      end
    end
  end

  describe 'Credit Card' do
    it 'generates proper request xml' do
      MockResponse.responds_with(:payment_method_credit_card_create_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :create,
          {
            message: '<zns:zObjects xsi:type="ons:PaymentMethod"><ons:AccountId>1</ons:AccountId>'\
              '<ons:CreditCardAddress1>123 Testing Lane</ons:CreditCardAddress1><ons:CreditCardCity>San Francisco'\
              '</ons:CreditCardCity><ons:CreditCardExpirationMonth>9</ons:CreditCardExpirationMonth>'\
              '<ons:CreditCardExpirationYear>2025</ons:CreditCardExpirationYear><ons:CreditCardHolderName>'\
              'Example User</ons:CreditCardHolderName><ons:CreditCardNumber>4111111111111111</ons:CreditCardNumber>'\
              '<ons:CreditCardPostalCode>95611</ons:CreditCardPostalCode><ons:CreditCardState>California'\
              '</ons:CreditCardState><ons:CreditCardType>Visa</ons:CreditCardType><ons:Type>CreditCard</ons:Type>'\
              '<ons:UseDefaultRetryRule>true</ons:UseDefaultRetryRule></zns:zObjects>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        FactoryBot.create(:payment_method_credit_card, :account => @account, credit_card_expiration_year: '2025')
      end
    end

    it 'masks credit card information' do
      MockResponse.responds_with(:payment_method_credit_card_find_success) do
        pm = Zuora::Objects::PaymentMethod.find('stub')
        pm.credit_card_number.should == '************1111'
      end
    end
  end

  context 'ACH' do
    it 'generates proper request xml' do
      MockResponse.responds_with(:payment_method_ach_create_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :create,
          {
            message: '<zns:zObjects xsi:type="ons:PaymentMethod"><ons:AccountId>1</ons:AccountId><ons:AchAbaCode>'\
              '123456789</ons:AchAbaCode><ons:AchAccountName>My Checking Account</ons:AchAccountName>'\
              '<ons:AchAccountNumber>987654321</ons:AchAccountNumber><ons:AchAccountType>BusinessChecking'\
              '</ons:AchAccountType><ons:AchBankName>Bank of Zuora</ons:AchBankName><ons:Type>ACH</ons:Type>'\
              '<ons:UseDefaultRetryRule>true</ons:UseDefaultRetryRule></zns:zObjects>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        FactoryBot.create(:payment_method_ach, account: @account)
      end
    end

    it 'masks bank information' do
      MockResponse.responds_with(:payment_method_ach_find_success) do
        pm = Zuora::Objects::PaymentMethod.find('stub')
        pm.ach_account_number.should == '*****4321'
      end
    end
  end

  context 'PayPal' do
    it 'generates proper request xml' do
      MockResponse.responds_with(:payment_method_ach_create_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :create,
          {
            message: '<zns:zObjects xsi:type="ons:PaymentMethod"><ons:AccountId>1</ons:AccountId><ons:PaypalBaid>'\
              'ExampleBillingAgreementId</ons:PaypalBaid><ons:PaypalEmail>example@example.org</ons:PaypalEmail>'\
              '<ons:PaypalType>ExpressCheckout</ons:PaypalType><ons:Type>PayPal</ons:Type><ons:UseDefaultRetryRule>'\
              'true</ons:UseDefaultRetryRule></zns:zObjects>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        FactoryBot.create(:payment_method_paypal, account: @account)
      end
    end
  end
end
