require File.expand_path('../test_helper', __FILE__)

module Larva
  class DaemonTest < Minitest::Test
    def config_dir
      File.expand_path('../../test', __FILE__)
    end

    def logfile
      "log/test.log"
    end

    def test_logfile_is_compulsary
      assert_raises(LarvaError, "Please provide :logfile via options") do
        Configurator.configure(config_dir: config_dir)
      end
    end

    def test_config_dir_is_compulsary
      assert_raises(LarvaError, "Please provide :config_dir via options") do
        Configurator.configure(logfile: logfile)
      end
    end

    def test_filum_gets_config
      Configurator.configure(logfile: logfile, config_dir: config_dir)
      assert_equal logfile, Filum.logger.logfile
    end

    def test_sdk_secret_key_can_be_overriden
      with_sdk_file do
        secret_key = "Foobar!"
        Configurator.configure(logfile: logfile, config_dir: config_dir, meducation_sdk_secret_key: secret_key)
        assert_equal secret_key, Loquor.config.secret_key
      end
    end

    def test_meducation_sdk_gets_config_in_dev
      with_sdk_file do
        Configurator.configure(config_dir: config_dir, logfile: logfile)
        assert_equal "LarvaSpawn", Loquor.config.access_id
        assert_equal "foobar", Loquor.config.secret_key
        assert_equal Filum.logger, MeducationSDK.config.logger
        assert_equal "http://localhost:3000/spi", Loquor.config.endpoint
      end
    end

    def test_meducation_sdk_gets_config_in_production
      with_sdk_file do
        Configurator.configure(config_dir: config_dir, logfile: logfile, env: 'production')
        assert_equal "LarvaSpawn", Loquor.config.access_id
        assert_raises(Loquor::LoquorConfigurationError) { Loquor.config.secret_key }
        assert_equal Filum.logger, MeducationSDK.config.logger
        assert_equal "http://spi.meducation.net", Loquor.config.endpoint
      end
    end

    def with_sdk_file
      sdk_yaml_path = File.expand_path('../../test/meducation-sdk.yml', __FILE__)
      sdk_file = <<-EOS
development:
  access_id: LarvaSpawn
  secret_key: 'foobar'

production:
  access_id: LarvaSpawn
      EOS
      begin
        File.open(sdk_yaml_path, "w") { |f| f.write(sdk_file) }
        yield
      ensure
        `rm #{sdk_yaml_path}`
      end
    end
  end
end
