module Larva
  class Configurator
    def after_configure
      if meducation_sdk_config = parse_config_file('meducation-sdk.yml')
        MeducationSDK.config do |config|
          config.access_id  = meducation_sdk_config[:access_id]

          # Don't use fetch for these as nil values might be deliberately passed it
          config.secret_key = @options[:meducation_sdk_secret_key] || meducation_sdk_config[:secret_key]
          config.endpoint   = @options[:meducation_sdk_endpoint] || "http://localhost:3000/spi" if @env == 'development'
          config.logger     = Filum.logger
        end
      end
    end
  end
end
