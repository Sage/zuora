# Zuora [![Build Status](https://secure.travis-ci.org/wildfireapp/zuora.png?branch=master)](http://travis-ci.org/wildfireapp/zuora) [![Gemnasium](https://gemnasium.com/wildfireapp/zuora.png)](https://gemnasium.com/wildfireapp/zuora)

This library allows you to interact with [Zuora](http://www.zuora.com) billing platform directly using 
familiar [ActiveModel](https://github.com/rails/rails/tree/master/activemodel) based objects.

## Requirements
  * [bundler](https://github.com/carlhuda/bundler)
  * [active_support](https://github.com/rails/rails/tree/master/activesupport)
  * [savon](https://github.com/rubiii/savon)
  * [wasabi](https://github.com/rubiii/wasabi)

All additional requirements for development should be referenced in the provided zuora.gemspec and Gemfile.

## Installation

    git clone git@github.com:Sage/zuora.git

## Getting Started

    $ bundle install
    $ bundle exec irb -rzuora

```
  Zuora.configure(:username => 'USER', :password => 'PASS', sandbox: true, log: true)
    
  account = Zuora::Objects::Account.new
   => #<Zuora::Objects::Account:0x00000002cd25b0 @changed_attributes={"auto_pay"=>nil, "currency"=>nil, 
  "batch"=>nil, "bill_cycle_day"=>nil, "status"=>nil, "payment_term"=>nil}, @auto_pay=false, @currency="USD",
  @batch="Batch1", @bill_cycle_day=1, @status="Draft", @payment_term="Due Upon Receipt">
  
  account.name = "Test"
   => "Test"
   
  account.create
   => true
  
  created_account = Zuora::Objects::Account.find(account.id)
   => #<Zuora::Objects::Account:0x00000003caafc8 @changed_attributes={}, @auto_pay=false, @currency="USD", 
  @batch="Batch1", @bill_cycle_day=1, @status="Draft", @payment_term="Due Upon Receipt", 
  @id="2c92c0f83c1de760013c449bc26e555b", @account_number="A00000008", @allow_invoice_edit=false, 
  @balance=#<BigDecimal:3c895f8,'0.0',9(18)>, @bcd_setting_option="ManualSet", 
  @created_by_id="2c92c0f83b02a9dc013b0a7e26a03d00", @created_date=Wed, 16 Jan 2013 10:25:24 -0800, 
  @invoice_delivery_prefs_email=false, @invoice_delivery_prefs_print=false, @name="Test", 
  @updated_by_id="2c92c0f83b02a9dc013b0a7e26a03d00", @updated_date=Wed, 16 Jan 2013 10:25:24 -0800>
```


## Test in Docker
  1. Run the below command to build a Docker container for the tests
  ```
  docker-compose up -d
  ```
  1. Run the below command to access the zuora Docker container
  ```
  docker exec -it -u0 zuora bash
  ```
  1. Run the command below to install the dependencies for each appraisal
  ```
  bundle exec appraisal install
  ```
  1. Run the below command to run tests using the dependencies configured for Rails 5
  ```
  bundle exec appraisal rails-5 bundle exec rspec -t ~type:integration --force-color --format doc
  ```

## Multiple Connectors
  There are mutiple connectors available to us to communicate from library to Zuora (or even a test
  SQLite database)

  To set your connector:

    Zuora::Objects::Base.connector_class = Zuora::YourChosenConnector

### Default SOAPConnector
  This one is for normal usage, and is configured in the usual way. You do not need to explicitly
  set this connector.  It uses the SOAP api for Zuora

### SQLite Connector
  This connector is for usage in tests, and allows you to model fixtures and factories using the
  ZObjects, but within an in memory SQLite database.  To use this:

    require 'zuora/sqlite_connector'
    Zuora::Objects::Base.connector_class = Zuora::SqliteConnector
    Zuora::SqliteConnector.build_schema #Builds the sqlite schema from the ZObjects defined

### Multiple Config SOAPConnector
  This connector is for when you need to authenticate with Zuora using mutiple credentials, and
  allows you to specify within a block which config to use.  This is done per-thread, so will
  not effect other requests.

    Zuora::Objects::Base.connector_class = Zuora::MultiSoapConnector

    # Note we don't use Zuora.configure, as that's global:
    Zuora::MultiSoapConnector.configure :named_config, :username => 'u', :password => 'p'
    Zuora::MultiSoapConnector.configure :another_config, :username => 'u2', :password => 'p2'

    #To select a specific one at run time (required)
    Zuora::MultiSoapConnector.use_config :named_config do
      # Make use of ZObjects where, will authenticate and use
      # specific config
      Accounts.where('condition = TRUE')
    end

## Live Integration Suite
  There is also a live suite which you can test against your sandbox account.
  This can by ran by setting up your credentials and running the integration suite.

  **Do not run this suite using your production credentials. Doing so may destroy
  data although every precaution has been made to avoid any destructive behavior.**

      $ ZUORA_USER=login ZUORA_PASS=password rake spec:integrations

## Support & Maintenance
  This library currently supports Zuora's SOAP API version 38.

  If you would like to test out the **EXPERIMENTAL** API version 51 support, see
  the a51 branch and please file bugs and pull requests against it.

## Contributors
  * Josh Martin <joshuamartin@google.com>
  * Alex Reyes <alexreyes@google.com>
  * Wael Nasreddine <wnasreddine@google.com>
  * [mdemin914](http://github.com/mdemin914)
  * [jmonline](http://github.com/jmonline)

## Credits
  * [Wildfire Ineractive](http://www.wildfireapp.com) for facilitating the development and maintenance of the project.
  * [Zuora](http://www.zuora.com) for providing us with the opportunity to share this library with the community.

#Legal Notice
      Copyright (c) 2013 Zuora, Inc.
	  
      Permission is hereby granted, free of charge, to any person obtaining a copy of 
	  this software and associated documentation files (the "Software"), to use copy, 
	  modify, merge, publish the Software and to distribute, and sublicense copies of 
	  the Software, provided no fee is charged for the Software.  In addition the
	  rights specified above are conditioned upon the following:
	
	  The above copyright notice and this permission notice shall be included in all
	  copies or substantial portions of the Software.
	
	  Zuora, Inc. or any other trademarks of Zuora, Inc.  may not be used to endorse
	  or promote products derived from this Software without specific prior written
	  permission from Zuora, Inc.
	
	  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
	  ZUORA, INC. BE LIABLE FOR ANY DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES
	  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
	  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
	
	  IN THE EVENT YOU ARE AN EXISTING ZUORA CUSTOMER, USE OF THIS SOFTWARE IS GOVERNED
	  BY THIS AGREEMENT AND NOT YOUR MASTER SUBSCRIPTION AGREEMENT WITH ZUORA.
