require 'spec_helper'

describe Zuora::Objects::SubscribeRequest do
  before do
    allow_any_instance_of(Zuora::Api).to receive(:session).and_return double(key: 'session_key')
  end

  describe 'most persistence methods' do
    it 'are not publicly available' do
      [:update, :destroy, :where, :find].each do |meth|
        expect(subject.public_methods).to_not include(meth)
      end
    end
  end

  describe 'generating a request' do
    let(:sub_name) { subject.subscription.name }
    before(:all) do
      Timecop.freeze(Time.now)
    end

    after(:all) do
      Timecop.return
    end

    before do
      MockResponse.responds_with(:account_find_success) do
        @account = subject.account = Zuora::Objects::Account.find('stub')
      end

      MockResponse.responds_with(:contact_find_success) do
        subject.bill_to_contact = Zuora::Objects::Contact.find('stub')
      end

      MockResponse.responds_with(:payment_method_credit_card_find_success) do
        subject.payment_method = Zuora::Objects::PaymentMethod.find('stub')
      end

      MockResponse.responds_with(:product_rate_plan_find_success) do
        subject.product_rate_plan = Zuora::Objects::ProductRatePlan.find('stub')
      end

      subject.subscription = FactoryBot.build(:subscription)
    end

    it 'provides properly formatted xml when using existing objects' do
      MockResponse.responds_with(:subscribe_request_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :subscribe,
          {
            message: '<zns:subscribes><zns:Account><ons:Id>4028e488348752ce0134876a25867cb2</ons:Id></zns:Account>'\
              '<zns:PaymentMethod><ons:Id>4028e48834aa10a30134c50f40901ea7</ons:Id></zns:PaymentMethod>'\
              '<zns:BillToContact><ons:Id>4028e4873491cc770134972e75746e4c</ons:Id></zns:BillToContact>'\
              '<zns:SubscriptionData><zns:Subscription><ons:AutoRenew>false</ons:AutoRenew><ons:ContractEffectiveDate>'\
              "#{Time.now.rfc3339}</ons:ContractEffectiveDate><ons:InitialTerm>1</ons:InitialTerm>"\
              "<ons:IsInvoiceSeparate>false</ons:IsInvoiceSeparate><ons:Name>#{sub_name}</ons:Name>"\
              "<ons:RenewalTerm>0</ons:RenewalTerm><ons:TermStartDate>#{Time.now.rfc3339}</ons:TermStartDate>"\
              '</zns:Subscription><zns:RatePlanData><zns:RatePlan><ons:ProductRatePlanId>'\
              '4028e4883491c50901349d0e1e571341</ons:ProductRatePlanId></zns:RatePlan></zns:RatePlanData>'\
              '</zns:SubscriptionData></zns:subscribes>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(subject).to be_valid
        expect(subject.create).to be true
      end
    end

    it 'provides full account info when new object' do
      subject.account = FactoryBot.build(:account)

      MockResponse.responds_with(:subscribe_request_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :subscribe,
          {
            message: '<zns:subscribes><zns:Account><ons:AccountNumber>test_account_1</ons:AccountNumber><ons:AutoPay>'\
              'false</ons:AutoPay><ons:Batch>Batch1</ons:Batch><ons:BillCycleDay>1</ons:BillCycleDay><ons:Currency>USD'\
              '</ons:Currency><ons:Name>Test Account 1</ons:Name><ons:PaymentTerm>Due Upon Receipt</ons:PaymentTerm>'\
              '<ons:Status>Draft</ons:Status></zns:Account><zns:PaymentMethod><ons:Id>4028e48834aa10a30134c50f40901ea7'\
              '</ons:Id></zns:PaymentMethod><zns:BillToContact><ons:Id>4028e4873491cc770134972e75746e4c</ons:Id>'\
              '</zns:BillToContact><zns:SubscriptionData><zns:Subscription><ons:AutoRenew>false</ons:AutoRenew>'\
              "<ons:ContractEffectiveDate>#{Time.now.rfc3339}</ons:ContractEffectiveDate><ons:InitialTerm>1"\
              "</ons:InitialTerm><ons:IsInvoiceSeparate>false</ons:IsInvoiceSeparate><ons:Name>#{sub_name}</ons:Name>"\
              "<ons:RenewalTerm>0</ons:RenewalTerm><ons:TermStartDate>#{Time.now.rfc3339}</ons:TermStartDate>"\
              '</zns:Subscription><zns:RatePlanData><zns:RatePlan><ons:ProductRatePlanId>'\
              '4028e4883491c50901349d0e1e571341</ons:ProductRatePlanId></zns:RatePlan></zns:RatePlanData>'\
              '</zns:SubscriptionData></zns:subscribes>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(subject).to be_valid
        expect(subject.create).to be true
      end
    end

    it 'provides full bill_to_contact info when new object' do
      subject.bill_to_contact = FactoryBot.build(:contact, :account => @account)

      MockResponse.responds_with(:subscribe_request_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :subscribe,
          {
            message: '<zns:subscribes><zns:Account><ons:Id>4028e488348752ce0134876a25867cb2</ons:Id></zns:Account>'\
              '<zns:PaymentMethod><ons:Id>4028e48834aa10a30134c50f40901ea7</ons:Id></zns:PaymentMethod>'\
              '<zns:BillToContact><ons:AccountId>4028e488348752ce0134876a25867cb2</ons:AccountId><ons:FirstName>'\
              'Example</ons:FirstName><ons:LastName>User 1</ons:LastName></zns:BillToContact><zns:SubscriptionData>'\
              "<zns:Subscription><ons:AutoRenew>false</ons:AutoRenew><ons:ContractEffectiveDate>#{Time.now.rfc3339}"\
              '</ons:ContractEffectiveDate><ons:InitialTerm>1</ons:InitialTerm><ons:IsInvoiceSeparate>false'\
              "</ons:IsInvoiceSeparate><ons:Name>#{sub_name}</ons:Name><ons:RenewalTerm>0</ons:RenewalTerm>"\
              "<ons:TermStartDate>#{Time.now.rfc3339}</ons:TermStartDate></zns:Subscription><zns:RatePlanData>"\
              '<zns:RatePlan><ons:ProductRatePlanId>4028e4883491c50901349d0e1e571341</ons:ProductRatePlanId>'\
              '</zns:RatePlan></zns:RatePlanData></zns:SubscriptionData></zns:subscribes>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(subject).to be_valid
        expect(subject.create).to be true
      end
    end

    it 'provides full payment_method info when new object' do
      subject.payment_method = FactoryBot.build(:payment_method_ach, account: @account, ach_account_name: 'Testing')

      MockResponse.responds_with(:subscribe_request_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :subscribe,
          {
            message: '<zns:subscribes><zns:Account><ons:Id>4028e488348752ce0134876a25867cb2</ons:Id></zns:Account>'\
            '<zns:PaymentMethod><ons:AccountId>4028e488348752ce0134876a25867cb2</ons:AccountId><ons:AchAbaCode>'\
            '123456789</ons:AchAbaCode><ons:AchAccountName>Testing</ons:AchAccountName><ons:AchAccountNumber>987654321'\
            '</ons:AchAccountNumber><ons:AchAccountType>BusinessChecking</ons:AchAccountType><ons:AchBankName>'\
            'Bank of Zuora</ons:AchBankName><ons:Type>ACH</ons:Type><ons:UseDefaultRetryRule>true'\
            '</ons:UseDefaultRetryRule></zns:PaymentMethod><zns:BillToContact><ons:Id>4028e4873491cc770134972e75746e4c'\
            '</ons:Id></zns:BillToContact><zns:SubscriptionData><zns:Subscription><ons:AutoRenew>false</ons:AutoRenew>'\
            "<ons:ContractEffectiveDate>#{Time.now.rfc3339}</ons:ContractEffectiveDate><ons:InitialTerm>1"\
            "</ons:InitialTerm><ons:IsInvoiceSeparate>false</ons:IsInvoiceSeparate><ons:Name>#{sub_name}"\
            "</ons:Name><ons:RenewalTerm>0</ons:RenewalTerm><ons:TermStartDate>#{Time.now.rfc3339}</ons:TermStartDate>"\
            '</zns:Subscription><zns:RatePlanData><zns:RatePlan><ons:ProductRatePlanId>'\
            '4028e4883491c50901349d0e1e571341</ons:ProductRatePlanId></zns:RatePlan></zns:RatePlanData>'\
            '</zns:SubscriptionData></zns:subscribes>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(subject).to be_valid
        expect(subject.create).to be true
      end
    end

    it 'handles applying subscribe failures messages' do
      MockResponse.responds_with(:subscribe_request_failure) do
        expect(subject).to be_valid
        expect(subject.create).to be false
        expect(subject.errors.messages[:base]).to include('Initial Term should be greater than zero')
      end
    end

    it 'supports subscription options' do
      MockResponse.responds_with(:subscribe_request_success) do
        subject.subscribe_options = { generate_invoice: true, process_payments: true }
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :subscribe,
          {
            message: '<zns:subscribes><zns:Account><ons:Id>4028e488348752ce0134876a25867cb2</ons:Id></zns:Account>'\
              '<zns:PaymentMethod><ons:Id>4028e48834aa10a30134c50f40901ea7</ons:Id></zns:PaymentMethod>'\
              '<zns:BillToContact><ons:Id>4028e4873491cc770134972e75746e4c</ons:Id></zns:BillToContact>'\
              '<zns:SubscribeOptions><zns:GenerateInvoice>true</zns:GenerateInvoice><zns:ProcessPayments>true'\
              '</zns:ProcessPayments></zns:SubscribeOptions><zns:SubscriptionData><zns:Subscription><ons:AutoRenew>'\
              "false</ons:AutoRenew><ons:ContractEffectiveDate>#{Time.now.rfc3339}</ons:ContractEffectiveDate>"\
              '<ons:InitialTerm>1</ons:InitialTerm><ons:IsInvoiceSeparate>false</ons:IsInvoiceSeparate><ons:Name>'\
              "#{sub_name}</ons:Name><ons:RenewalTerm>0</ons:RenewalTerm><ons:TermStartDate>"\
              "#{Time.now.rfc3339}</ons:TermStartDate></zns:Subscription><zns:RatePlanData><zns:RatePlan>"\
              '<ons:ProductRatePlanId>4028e4883491c50901349d0e1e571341</ons:ProductRatePlanId></zns:RatePlan>'\
              '</zns:RatePlanData></zns:SubscriptionData></zns:subscribes>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(subject).to be_valid
        expect(subject.create).to be true
      end
    end

    it 'applies valid response data to the proper nested objects and resets dirty' do
      MockResponse.responds_with(:subscribe_request_success) do
        expect(subject).to be_valid
        expect(subject.create).to be true
        expect(subject.subscription).to_not be_new_record
      end
    end
  end
end
