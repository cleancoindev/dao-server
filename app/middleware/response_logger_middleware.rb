# frozen_string_literal: true

require 'pp'

class ResponseLoggerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    begin
      data = JSON.parse(response.body)

      Rails.logger.debug('Response Data:')
      Rails.logger.debug(JSON.pretty_generate(data))
    rescue StandardError
      Rails.logger.debug('Could not parse payload')
    end

    [status, headers, response]
  end
end
