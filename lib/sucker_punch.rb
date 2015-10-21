require 'concurrent'
require 'sucker_punch/job'
require 'sucker_punch/queue'
require 'sucker_punch/version'
require 'logger'

module SuckerPunch
  class << self
    def exception_handler(&block)
      @handler = block
    end

    def handler
      @handler || method(:default_handler)
    end

    def default_handler(ex)
      error_msg = "Job processing error: #{ex.class} #{ex}\n#{ex.backtrace.nil? ? '' : ex.backtrace.join("\n")}"
      logger.error error_msg
    end

    def logger
      @logger || default_logger
    end

    def logger=(log)
      @logger = (log ? log : Logger.new('/dev/null'))
    end

    def default_logger
      l = Logger.new(STDOUT)
      l.level = Logger::INFO
      l
    end

  end
end

require 'sucker_punch/railtie' if defined?(::Rails)
