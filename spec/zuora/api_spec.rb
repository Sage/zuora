require 'spec_helper'

describe Zuora::Api do
  subject { Zuora::Api.instance }

  describe 'configuration' do
    before do
      Zuora::Api.any_instance.stub(:authenticated?).and_return(true)
    end

    it 'uses provided wsdl_path' do
      expect(Zuora::Api.instance.client.wsdl.endpoint.to_s).to eq 'https://www.zuora.com/apps/services/a/38.0'
    end

    it "can be configured multiple times" do
      Zuora.configure(:username => 'example', :password => 'test')
      Zuora::Api.instance.config.should be_a_kind_of(Zuora::Config)
      Zuora.configure(:username => 'changed', :password => 'changed')

      Zuora::Api.instance.config.username.should == 'changed'
      Zuora::Api.instance.config.password.should == 'changed'
    end
  end

  describe "logger support" do
    it "allows using custom logger" do
      MockResponse.responds_with(:valid_login) do
        logger = Logger.new('zuora.log')
        Zuora.configure(:username => 'example', :password => 'test', :logger => logger)
        Zuora::Api.instance.authenticate!
      end
    end
  end

  describe "authentication", type: :integration do
    it "creates Zuora::Session instance when successful" do
      MockResponse.responds_with(:valid_login) do
        Zuora.configure(:username => 'example', :password => 'test')
        Zuora::Api.instance.authenticate!
        Zuora::Api.instance.should be_authenticated
      end
    end

    it "raises exception when invalid login is provided" do
      MockResponse.responds_with(:invalid_login, 500) do
        lambda do
          Zuora.configure(:username => 'example', :password => 'test')
          Zuora::Api.instance.authenticate!
        end.should raise_error(Zuora::Fault)
      end
    end

    it "raises exception when IOError is found" do
      Zuora::Api.instance.client.should_receive(:call).and_raise(IOError.new)
      Zuora.configure(:username => 'example', :password => 'test')
      lambda do
        Zuora::Api.instance.request(:query)
      end.should raise_error(Zuora::Fault)
    end
  end

  describe 'download', type: :integration do
    it "uses NET::HTTP to download the csv" do
      Zuora.configure(
        :username => 'example',
        :password => 'test',
        :download_url => 'http://example.com/foo/bar'
      )

      export = ::Zuora::Objects::Export.new
      export.file_id = 'FOOBAR_FILE'

      Net::HTTP.any_instance.should_receive(:start).and_return(double(Object, :body => ''))

      subject.download(export)
    end
  end
end
