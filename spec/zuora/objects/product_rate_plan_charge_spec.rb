# frozen_string_literal: true

require 'spec_helper'

describe Zuora::Objects::ProductRatePlanCharge do
  before do
    allow_any_instance_of(Zuora::Api).to receive(:session).and_return double(key: 'session_key')
  end

  context 'complex association support' do
    it 'should have blank association for new object' do
      subject.product_rate_plan_charge_tiers.should == []
    end

    it 'should allow adding objects to the association' do
      obj = double('Example')
      subject.product_rate_plan_charge_tiers << obj
      subject.product_rate_plan_charge_tiers.should == [obj]
    end

    it 'should load remote associations when not a new record' do
      subject.id = 'test'
      expect(subject).to_not be_new_record

      MockResponse.responds_with(:product_rate_plan_charge_tier_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select Active, CreatedById, CreatedDate, Currency, EndingUnit, IsOveragePrice, '\
              'Price, PriceFormat, ProductRatePlanChargeId, StartingUnit, Tier, UpdatedById, UpdatedDate, Id from '\
              "ProductRatePlanChargeTier where ProductRatePlanChargeId = 'test'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        expect(subject.product_rate_plan_charge_tiers.size).to eq 2
      end
    end

    it 'should not include complex attributes in the request' do
      MockResponse.responds_with(:product_rate_plan_charge_tier_find_success) do
        expect(Zuora::Api.instance.client).to receive(:call).with(
          :query,
          {
            message: '<zns:queryString>select AccountingCode, BillCycleDay, BillCycleType, BillingPeriod, '\
              'BillingPeriodAlignment, ChargeModel, ChargeType, CreatedById, CreatedDate, DefaultQuantity, Description'\
              ', IncludedUnits, MaxQuantity, MinQuantity, Name, NumberOfPeriod, OverageCalculationOption, '\
              'OverageUnusedUnitsCreditOption, PriceIncreaseOption, PriceIncreasePercentage, ProductRatePlanId, '\
              'RevRecCode, RevRecTriggerCondition, SmoothingModel, SpecificBillingPeriod, TriggerEvent, Uom, '\
              'UpdatedById, UpdatedDate, UseDiscountSpecificAccountingCode, Id from ProductRatePlanCharge where Id = '\
              "'example'</zns:queryString>",
            soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
          }
        ).and_call_original
        subject.class.find('example')
      end
    end
  end

  it 'can create a product rate plan with several charge tiers' do
    MockResponse.responds_with(:product_find_success) do
      @product = Zuora::Objects::Product.find('4028e4883491c50901349d061be06550')
    end

    MockResponse.responds_with(:product_rate_plan_find_success) do
      @prp = @product.product_rate_plans.first
    end

    @prpc = Zuora::Objects::ProductRatePlanCharge.new do |c|
      c.product_rate_plan = @prp
      c.name = 'Monthly Allowance'
      c.bill_cycle_type = 'DefaultFromCustomer'
      c.billing_period = 'Month'
      c.billing_period_alignment = 'AlignToCharge'
      c.charge_model = 'Volume Pricing'
      c.charge_type = 'Recurring'
      c.included_units = '10'
      c.smoothing_model = 'Rollover'
      c.uom = 'Each'
      c.trigger_event = 'ServiceActivation'
    end

    expect(@prpc.product_rate_plan_charge_tiers).to eq []

    tier1 = Zuora::Objects::ProductRatePlanChargeTier.new do |t|
      t.price = 0
      t.starting_unit = 0
      t.ending_unit = 10
    end

    tier2 = Zuora::Objects::ProductRatePlanChargeTier.new do |t|
      t.price = 50
      t.starting_unit = 11
      t.ending_unit = 20
    end

    expect(@prpc).to_not be_valid, 'tiers are required to be valid'
    @prpc.product_rate_plan_charge_tiers << tier1
    @prpc.product_rate_plan_charge_tiers << tier2
    expect(@prpc).to be_valid, 'tiers are required to be valid'

    MockResponse.responds_with(:product_rate_plan_charge_create_success) do
      expect(Zuora::Api.instance.client).to receive(:call).with(
        :create,
        {
          message: '<zns:zObjects xsi:type="ons:ProductRatePlanCharge"><ons:BillCycleType>DefaultFromCustomer'\
            '</ons:BillCycleType><ons:BillingPeriod>Month</ons:BillingPeriod><ons:BillingPeriodAlignment>AlignToCharge'\
            '</ons:BillingPeriodAlignment><ons:ChargeModel>Volume Pricing</ons:ChargeModel><ons:ChargeType>Recurring'\
            '</ons:ChargeType><ons:IncludedUnits>10</ons:IncludedUnits><ons:Name>Monthly Allowance</ons:Name>'\
            '<ons:ProductRatePlanId>4028e4883491c50901349d0e1e571341</ons:ProductRatePlanId><ons:SmoothingModel>'\
            'Rollover</ons:SmoothingModel><ons:TriggerEvent>ServiceActivation</ons:TriggerEvent><ons:Uom>Each'\
            '</ons:Uom><ons:ProductRatePlanChargeTierData><zns:ProductRatePlanChargeTier '\
            'xsi:type="ons:ProductRatePlanChargeTier"><ons:Currency>USD</ons:Currency><ons:EndingUnit>10'\
            '</ons:EndingUnit><ons:Price>0</ons:Price><ons:StartingUnit>0</ons:StartingUnit>'\
            '</zns:ProductRatePlanChargeTier><zns:ProductRatePlanChargeTier xsi:type="ons:ProductRatePlanChargeTier">'\
            '<ons:Currency>USD</ons:Currency><ons:EndingUnit>20</ons:EndingUnit><ons:Price>50</ons:Price>'\
            '<ons:StartingUnit>11</ons:StartingUnit></zns:ProductRatePlanChargeTier>'\
            '</ons:ProductRatePlanChargeTierData></zns:zObjects>',
          soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
        }
      ).and_call_original
      expect(@prpc.save).to be true
      expect(@prpc).to_not be_new_record
    end

    MockResponse.responds_with(:product_rate_plan_charge_tier_find_success) do
      expect(Zuora::Api.instance.client).to receive(:call).with(
        :query,
        {
          message: '<zns:queryString>select Active, CreatedById, CreatedDate, Currency, EndingUnit, IsOveragePrice, '\
            'Price, PriceFormat, ProductRatePlanChargeId, StartingUnit, Tier, UpdatedById, UpdatedDate, Id from '\
            "ProductRatePlanChargeTier where ProductRatePlanChargeId = '4028e48834aa10a30134aaf7f40b3139'"\
            '</zns:queryString>',
          soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
        }
      ).and_call_original
      @prpct = @prpc.product_rate_plan_charge_tiers
      expect(@prpct.size).to eq 2
    end

    expect(@prpct.map(&:new_record?)).to be_none, 'complex objects should not be new records after save'
    @prpc.product_rate_plan_charge_tiers.first.price = 20
    expect(@prpc.product_rate_plan_charge_tiers.first.price).to eq 20

    MockResponse.responds_with(:product_rate_plan_charge_update_success) do
      expect(Zuora::Api.instance.client).to receive(:call).with(
        :update,
        {
          message: '<zns:zObjects xsi:type="ons:ProductRatePlanCharge"><ons:Id>4028e48834aa10a30134aaf7f40b3139'\
            '</ons:Id><ons:ProductRatePlanChargeTierData><zns:ProductRatePlanChargeTier '\
            'xsi:type="ons:ProductRatePlanChargeTier"><ons:Active>true</ons:Active><ons:Price>20</ons:Price>'\
            '<ons:ProductRatePlanChargeId>4028e48834aa10a30134aaf7f40b3139</ons:ProductRatePlanChargeId><ons:Id>'\
            '4028e48834aa10a30134aaf7f40b313a</ons:Id></zns:ProductRatePlanChargeTier><zns:ProductRatePlanChargeTier '\
            'xsi:type="ons:ProductRatePlanChargeTier"><ons:Active>true</ons:Active><ons:Price>50.0</ons:Price>'\
            '<ons:ProductRatePlanChargeId>4028e48834aa10a30134aaf7f40b3139</ons:ProductRatePlanChargeId>'\
            '<ons:Id>4028e48834aa10a30134aaf7f40b313b</ons:Id></zns:ProductRatePlanChargeTier>'\
            '</ons:ProductRatePlanChargeTierData></zns:zObjects>',
          soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
        }
      ).and_call_original
      expect(@prpc.save).to eq true
    end

    MockResponse.responds_with(:product_rate_plan_charge_destroy_success) do
      expect(Zuora::Api.instance.client).to receive(:call).with(
        :delete,
        {
          message: '<zns:type>ProductRatePlanCharge</zns:type><zns:ids>4028e48834aa10a30134aaf7f40b3139</zns:ids>',
          soap_header: { 'env:SessionHeader' => {  'zns:Session' => 'session_key' } }
        }
      ).and_call_original
      @prpc.destroy
    end
  end
end
