require 'savon'
require 'net/http'

module Zuora

  # Configure Zuora by passing in an options hash. This must be done before
  # you can use any of the Zuora::Object models.
  # @example
  #   Zuora.configure(:username => 'USERNAME', :password => 'PASSWORD')
  # @param [Hash] configuration option hash
  # @return [Config]
  def self.configure(opts={})
    Api.instance.config = Config.new(opts)
    HTTPI.logger = opts[:logger]
    HTTPI.log = opts[:logger] ? true : false
  end

  class Api
    # @return [Savon::Client]
    attr_accessor :client

    # @return [Zuora::Session]
    attr_accessor :session

    # @return [Zuora::Config]
    attr_accessor :config

    SOAP_VERSION = 2

    def self.instance
      @instance ||= new
    end

    # Is this an authenticated session?
    # @return [Boolean]
    def authenticated?
      self.session.try(:active?)
    end

    # The XML that was transmited in the last request
    # @return [String]
    def last_request
      client.http.body
    end

    # Generate an API request with the given block.  The block yields an xml
    # builder instance which can be used to build out the request as needed.
    # You can also provide the xml_body which will be used instead of the block.
    # @param [Symbol] symbol of the WSDL operation to call
    # @param [String] string xml body pass to the operation
    # @yield [Builder] xml builder instance
    # @raise [Zuora::Fault]
    def request(method, options={}, &block)
      authenticate! unless authenticated?

      if block_given?
        xml = Builder::XmlMarkup.new
        yield xml
        options[:message] = xml.target!
      end
      options[:soap_header] = { 'env:SessionHeader' => { 'zns:Session' => self.session.try(:key) } }

      client.call(method, options)
    rescue Savon::SOAPFault, IOError => e
      raise Zuora::Fault.new(:message => e.message)
    end

    def download(export)
      authenticate! unless authenticated?

      uri = URI(URI.join(config.download_url, export.file_id))
      req = Net::HTTP::Get.new(uri.request_uri)
      req['Authorization'] = 'ZSession ' + session.try(:key)

      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true

      res = http.start { |http| http.request(req) }
      res.body
    end

    # Attempt to authenticate against Zuora and initialize the Zuora::Session object
    #
    # @note that the Zuora API requires username to come first in the SOAP request so
    # it is manually generated here instead of simply passing an ordered hash to the client.
    #
    # Upon failure a Zoura::Fault will be raised.
    # @raise [Zuora::Fault]
    def authenticate!
      response = client.call(:login, message: { username: config.username,  password: config.password })

      self.session = Zuora::Session.generate(response.to_hash)
    rescue Savon::SOAPFault, IOError => e
      raise Zuora::Fault.new(:message => e.message)
    end

    def client
      return @client if @client

      @client = Savon.client(
        wsdl: config&.wsdl_path ? config.wsdl_path : File.expand_path('../../../wsdl/zuora.a.38.0.wsdl', __FILE__),
        ssl_verify_mode: :none,
        soap_version: SOAP_VERSION,
        log: log: config&.log || true,
        filters: [:password]
      )
    end
  end
end
