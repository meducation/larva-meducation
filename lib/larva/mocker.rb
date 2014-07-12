module Larva
  class Mocker
    def self.after_mock
      MeducationSDK.config do |config|
        config.endpoint   = "http://localhost:3000/spi"
        config.access_id  = "Daemon"
        config.secret_key = "foobar"
        config.logger     = Filum.logger
      end
    end
  end
end
