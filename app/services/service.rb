# frozen_string_literal: true

class Service # rubocop:todo Style/Documentation
  
   def self.get(url:, xheaders: nil, params: {}, model_name: nil)
    headers = xheaders
    request = Typhoeus::Request.new(url, method: :get, headers: headers, params: params)
    commit request
    processed_response = process request.response
    wrap processed_response, model_name: model_name
  end

  def self.wrap(coded_response, model_name: nil)
    response_type = coded_response[:code] > 300 ? 'error' : 'valid'
    klass_name = "#{response_type}_response"
    klass = klass_name.classify.constantize
    Rails.logger.info "#{klass.new(coded_response, model_name: model_name)}"
    Rails.logger.info 'model_name'
    Rails.logger.info model_name
    klass.new(coded_response, model_name: model_name)
  end

  def self.process(rsp)
    headers = process_headers(rsp.options[:response_headers])
    coded_response = {
      code: rsp.options[:response_code],
      url: rsp.options[:effective_url],
      headers: headers,
      cookies: headers[:set_cookie],
      body: Oj.load(rsp.options[:response_body])
    }
    coded_response
  end

  def self.process_headers(str)
    str.split("\r\n")
       .map(&:strip)
       .map { |x| x.split(': ') }
       .map { |k, v| [k.underscore.to_sym, v] }
       .reject { |_k, v| v.nil? }
       .to_h
  end

  def self.commit(request)
    hydra = Typhoeus::Hydra.hydra
    hydra.queue(request)
    hydra.run
  end
end
