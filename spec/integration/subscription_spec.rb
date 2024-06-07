require 'spec_helper'

describe 'Subscription', :skip do
  before :each do
    authenticate!
    @account = FactoryGirl.create(:active_account, account_number: generate_key)
    @product = FactoryGirl.create(:product_catalog, name: generate_key)
  end

  after :each do
    @account.destroy
    @product.destroy
  end

  it 'can be created' do
    payment_method = FactoryGirl.create(:payment_method_credit_card, account: @account)
    bill_to_contact = @account.contacts.first
    product_rate_plan = @product.product_rate_plans.first
    subscription = FactoryGirl.build(:subscription, account: @account)

    request = Zuora::Objects::SubscribeRequest.new(
      account: @account,
      bill_to_contact: bill_to_contact,
      payment_method: payment_method,
      product_rate_plan: product_rate_plan,
      subscription: subscription
    )

    expect(request).to be_valid
    expect(request.create).to be_truthy

    subscriptions = @account.subscriptions
    expect(subscriptions.size).to eq(1)

    subscription = subscriptions.first
    expect(subscription).to be_valid

    rps = subscription.rate_plans
    expect(rps.size).to eq(1)
    rp = rps.first
    expect(rp).to be_valid

    rpcs = rp.rate_plan_charges
    expect(rpcs.size).to eq(1)
    expect(rpcs.first).to be_valid

    expect(@account.invoices.size).to eq(1)
    invoice = @account.invoices.first
    expect(invoice.invoice_item_adjustments).to match_array([])
    expect(invoice.invoice_items.size).to eq(1)
    expect(invoice.invoice_adjustments).to match_array([])
  end
end
