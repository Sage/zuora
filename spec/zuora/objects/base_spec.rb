# frozen_string_literal: true

require 'spec_helper'

class SomeExampleObject < Zuora::Objects::Base
end

class SomeExampleConnector
  def initialize(model); end
end

describe Zuora::Objects::Base do
  describe ':connector' do
    it 'uses SoapConnector by default' do
      SomeExampleObject.connector.should be_a Zuora::SoapConnector
    end

    it 'allows injecting different class for tests' do
      described_class.connector_class = SomeExampleConnector
      SomeExampleObject.connector.should be_a SomeExampleConnector
      # reset for subsequent tests
      described_class.connector_class = Zuora::SoapConnector
    end
  end

  describe ':initializer' do
    it 'allows to overwrite default values' do
      expect(Zuora::Objects::Invoice.new.includes_usage).to be_truthy
      expect(Zuora::Objects::Invoice.new(includes_usage: false).includes_usage).to be_falsy
    end
  end
end
