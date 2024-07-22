require 'spec_helper'

describe Zuora::Objects::Account do
  let(:account_id) { '4028e488348752ce0134876a25867cb2' }

  before do
    allow_any_instance_of(Zuora::Api).to receive(:session).and_return double(key: 'session_key')
  end

  it_should_behave_like "ActiveModel"

  it "extends Base object" do
    subject.should be_a_kind_of(Zuora::Objects::Base)
  end

  it 'has defined attributes' do
    expect(subject.attributes.keys.map(&:to_s)).to match_array(%w(account_number additional_email_addresses
      allow_invoice_edit auto_pay balance batch bcd_setting_option bill_cycle_day bill_to_id communication_profile_id
      created_by_id created_date crm_id currency customer_service_rep_name default_payment_method_id id
      invoice_delivery_prefs_email invoice_delivery_prefs_print invoice_template_id last_invoice_date name notes
      payment_gateway payment_term purchase_order_number sales_rep_name sold_to_id status updated_by_id updated_date
    ))
  end

  it "has read only attributes" do
    subject.read_only_attributes.should == [
      :balance, :created_date, :credit_balance, :last_invoice_date, :parent_id, :total_invoice_balance, :updated_date, :created_by_id, :last_invoice_date, :updated_by_id
    ]
  end

  describe 'Dirty support' do
    it 'handles newly created records' do
      MockResponse.responds_with(:account_create_success) do
        expect(subject).to_not be_name_changed
        subject.name = "Example Account"
        subject.account_number = "abc123"
        subject.currency = 'USD'
        subject.status = 'Draft'
        expect(subject).to be_changed
        expect(subject.changes.keys).to match_array(
          %w(name auto_pay payment_term account_number currency batch bill_cycle_day status)
        )
        expect(subject.save).to be true
        expect(subject).to_not be_changed
      end
    end

    it "should consider defaulted attributes dirty for new records" do
      subject.should be_changed
    end
  end

  it "has default values" do
    subject.auto_pay.should == false
    subject.batch.should == 'Batch1'
    subject.bill_cycle_day.should == 1
    subject.payment_term.should == 'Due Upon Receipt'
  end

  it "has a remote model name" do
    subject.remote_name.should == 'Account'
    Zuora::Objects::Account.remote_name.to_s.should == 'Account'
  end

  it "can by casted to a hash" do
    subject.class.new(:id => 42).to_hash.should include({:id => 42})
  end

  describe 'finding a remote object' do
    it 'succeeds' do
      MockResponse.responds_with(:account_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountNumber, AdditionalEmailAddresses, AllowInvoiceEdit, AutoPay, '\
              'Balance, Batch, BcdSettingOption, BillCycleDay, BillToId, CommunicationProfileId, CreatedById, '\
              'CreatedDate, CrmId, Currency, CustomerServiceRepName, DefaultPaymentMethodId, '\
              'InvoiceDeliveryPrefsEmail, InvoiceDeliveryPrefsPrint, InvoiceTemplateId, LastInvoiceDate, Name, Notes, '\
              'PaymentGateway, PaymentTerm, PurchaseOrderNumber, SalesRepName, SoldToId, Status, UpdatedById, '\
              "UpdatedDate, Id from Account where Id = '#{account_id}'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(Zuora::Api.instance).to be_authenticated
        account = Zuora::Objects::Account.find(account_id)
        expect(account).to be_a_kind_of(Zuora::Objects::Account)
        expect(account.id).to eq account_id
        expect(account.name).to eq 'FooBar'
      end
    end

    it 'supports hash based lookups' do
      MockResponse.responds_with(:account_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountNumber, AdditionalEmailAddresses, AllowInvoiceEdit, AutoPay, '\
              'Balance, Batch, BcdSettingOption, BillCycleDay, BillToId, CommunicationProfileId, CreatedById, '\
              'CreatedDate, CrmId, Currency, CustomerServiceRepName, DefaultPaymentMethodId, '\
              'InvoiceDeliveryPrefsEmail, InvoiceDeliveryPrefsPrint, InvoiceTemplateId, LastInvoiceDate, Name, Notes, '\
              'PaymentGateway, PaymentTerm, PurchaseOrderNumber, SalesRepName, SoldToId, Status, UpdatedById, '\
              "UpdatedDate, Id from Account where Id = 'test' and Name = 'Bob'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        Zuora::Objects::Account.where(id: 'test', name: 'Bob')
      end
    end
  end

  describe 'updating a remote object' do
    it 'succeeds' do
      account = nil
      MockResponse.responds_with(:account_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountNumber, AdditionalEmailAddresses, AllowInvoiceEdit, AutoPay, '\
              'Balance, Batch, BcdSettingOption, BillCycleDay, BillToId, CommunicationProfileId, CreatedById, '\
              'CreatedDate, CrmId, Currency, CustomerServiceRepName, DefaultPaymentMethodId, '\
              'InvoiceDeliveryPrefsEmail, InvoiceDeliveryPrefsPrint, InvoiceTemplateId, LastInvoiceDate, Name, Notes, '\
              'PaymentGateway, PaymentTerm, PurchaseOrderNumber, SalesRepName, SoldToId, Status, UpdatedById, '\
              "UpdatedDate, Id from Account where Id = '#{account_id}'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        account = Zuora::Objects::Account.find(account_id)
      end

      MockResponse.responds_with(:account_update_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :update,
          {
            message: '<zns:zObjects xsi:type="ons:Account"><ons:Id>4028e488348752ce0134876a25867cb2</ons:Id><ons:Name>'\
              'FooMax</ons:Name></zns:zObjects>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        account.name = 'FooMax'
        expect(account).to be_changed
        expect(account.save).to eq true
        expect(account).to_not be_changed
      end
    end
  end

  describe 'creating a remote object' do
    it 'should succeed and set local id' do
      MockResponse.responds_with(:account_create_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :create,
          {
            message: '<zns:zObjects xsi:type="ons:Account"><ons:AccountNumber>example-test-10</ons:AccountNumber>'\
            '<ons:AutoPay>false</ons:AutoPay><ons:Batch>Batch1</ons:Batch><ons:BillCycleDay>1</ons:BillCycleDay>'\
            '<ons:Currency>USD</ons:Currency><ons:Name>Example Test Account</ons:Name><ons:PaymentTerm>Due Upon '\
            'Receipt</ons:PaymentTerm><ons:Status>Draft</ons:Status></zns:zObjects>',
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        a = Zuora::Objects::Account.new
        a.account_number = 'example-test-10'
        a.name = 'Example Test Account'
        a.batch = 'Batch1'
        expect(a).to be_valid
        expect(a.save).to be true
        expect(a.id).to eq '4028e4873491cc7701349574bfcb6af6'
      end
    end

    it "should fail and apply errors" do
      MockResponse.responds_with(:account_create_failure) do
        a = Zuora::Objects::Account.new
        a.account_number = 'example-test-10'
        a.name = 'Example Test Account'
        a.batch = 'Batch1'
        a.auto_pay = false
        a.bill_cycle_day = 1
        a.currency = 'USD'
        a.payment_term = 'Due Upon Receipt'
        a.status = 'Draft'
        a.should be_valid
        expect { a.save }.to raise_error StandardError
        a.id.should be_nil
      end
    end
  end

  describe 'deleting remote objects' do
    it 'should succeed' do
      MockResponse.responds_with(:account_delete_success) do
        id = '4028e4873491cc7701349574bfcb6af6'
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :delete,
          {
            message: "<zns:type>Account</zns:type><zns:ids>#{id}</zns:ids>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        a = Zuora::Objects::Account.new(id: id)
        expect(a).to be_persisted
        expect(a.destroy).to be true
      end
    end
  end

  describe 'querying remote objects' do
    it 'returns multiple objects via where' do
      MockResponse.responds_with(:account_query_multiple_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountNumber, AdditionalEmailAddresses, AllowInvoiceEdit, AutoPay, '\
              'Balance, Batch, BcdSettingOption, BillCycleDay, BillToId, CommunicationProfileId, CreatedById, '\
              'CreatedDate, CrmId, Currency, CustomerServiceRepName, DefaultPaymentMethodId, InvoiceDeliveryPrefsEmail'\
              ', InvoiceDeliveryPrefsPrint, InvoiceTemplateId, LastInvoiceDate, Name, Notes, PaymentGateway, '\
              'PaymentTerm, PurchaseOrderNumber, SalesRepName, SoldToId, Status, UpdatedById, UpdatedDate, Id from '\
              "Account where AccountNumber like 'test%'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        accounts = Zuora::Objects::Account.where("AccountNumber like 'test%'")
        expect(accounts.size).to eq 2
        expect(accounts.map(&:id)).to match_array(%w(4028e4883491c509013492cd13e2455f 4028e488348752ce0134876a25867cb2))
      end
    end
  end

  describe 'associations' do
    let(:id) { '4028e488348752ce0134876a25867cb2' }
    it 'has many contacts and reflect back' do
      account, contacts, contact = nil, nil, nil

      MockResponse.responds_with(:account_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountNumber, AdditionalEmailAddresses, AllowInvoiceEdit, AutoPay, '\
              'Balance, Batch, BcdSettingOption, BillCycleDay, BillToId, CommunicationProfileId, CreatedById, '\
              'CreatedDate, CrmId, Currency, CustomerServiceRepName, DefaultPaymentMethodId, InvoiceDeliveryPrefsEmail'\
              ', InvoiceDeliveryPrefsPrint, InvoiceTemplateId, LastInvoiceDate, Name, Notes, PaymentGateway, '\
              'PaymentTerm, PurchaseOrderNumber, SalesRepName, SoldToId, Status, UpdatedById, UpdatedDate, Id from '\
              "Account where Id = '#{id}'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        account = Zuora::Objects::Account.find(id)
      end

      MockResponse.responds_with(:account_contacts_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountId, Address1, Address2, City, Country, CreatedById, CreatedDate, '\
            'Fax, FirstName, HomePhone, LastName, MobilePhone, NickName, OtherPhone, OtherPhoneType, PersonalEmail, '\
            'PostalCode, State, UpdatedById, UpdatedDate, WorkEmail, WorkPhone, Id from Contact where AccountId = '\
            "'#{id}'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        contacts = account.contacts
        expect(contacts.size).to eq 1
      end

      MockResponse.responds_with(:account_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountNumber, AdditionalEmailAddresses, AllowInvoiceEdit, AutoPay, '\
              'Balance, Batch, BcdSettingOption, BillCycleDay, BillToId, CommunicationProfileId, CreatedById, '\
              'CreatedDate, CrmId, Currency, CustomerServiceRepName, DefaultPaymentMethodId, InvoiceDeliveryPrefsEmail'\
              ', InvoiceDeliveryPrefsPrint, InvoiceTemplateId, LastInvoiceDate, Name, Notes, PaymentGateway, '\
              'PaymentTerm, PurchaseOrderNumber, SalesRepName, SoldToId, Status, UpdatedById, UpdatedDate, Id from '\
              "Account where Id = '#{id}'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(contacts.first.account.id).to eq account.id
      end
    end
  end
end
