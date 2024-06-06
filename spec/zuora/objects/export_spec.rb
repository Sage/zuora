require 'spec_helper'

describe Zuora::Objects::Export do
  it_should_behave_like 'ActiveModel'

  it 'extends Base object' do
    subject.should be_a_kind_of(Zuora::Objects::Base)
  end

  it 'has defined attributes' do
    subject.attributes.keys.map(&:to_s).sort.should ==
      ['created_by_id', 'created_date', 'encrypted', 'file_id', 'format', 'id', 'name', 'query', 'size', 'status', 'status_reason', 'updated_by_id', 'updated_date', 'zip']
  end

  it 'has default values' do
    subject.format.should == 'csv'
  end

  describe 'download' do
    it 'makes a get request to the configured DOWNLOAD_URL with the correct header' do
      subject.stub(:connector).and_return(double(Object))
      subject.connector.should_receive(:download).with(subject)

      subject.download
    end
  end

  describe 'ready?' do
    it 'returns true if the status is Completed' do
      subject.status = 'Completed'
      subject.should be_ready
    end

    it 'returns false if the status is not Completed' do
      subject.status = 'NOTREADY'
      subject.should_not be_ready
    end
  end
end
