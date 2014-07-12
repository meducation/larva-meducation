module Larva
  class DaemonCreator
    def alter_files
      # Alter Gemfile
      gemfile_path = "#{daemon_dir}/Gemfile"
      gemfile = File.read(gemfile_path)
      gemfile.sub!("gem 'larva'", "gem 'larva_meducation'")
      File.open(gemfile_path, "w") { |f| f.write(gemfile) }

      # Alter main file
      main_file_path = "#{daemon_dir}/lib/#{daemon_name}.rb"
      main_file = File.read(main_file_path)
      main_file.sub!("require 'larva'", "require 'larva_meducation")
      File.open(main_file_path, "w") { |f| f.write(main_file) }

      # Alter rake task
      rake_task_path = "#{daemon_dir}/lib/tasks/#{daemon_name}.rake"
      rake_task = File.read(rake_task_path)
      rake_task.sub!("env: ENV['ENV'],", "env: ENV['ENV'],\n      meducation_sdk_secret_key: ENV['#{daemon_name.upcase}_API_KEY'],")
      File.open(rake_task_path, "w") { |f| f.write(rake_task) }

      # Alter test helper
      test_helper_path = "#{daemon_dir}/test/test_helper.rb"
      test_helper = File.read(test_helper_path)
      test_helper.sub!("require '#{daemon_name}'", "require '#{daemon_name}'\nMeducationSDK.mock!")
      File.open(test_helper_path, "w") { |f| f.write(test_helper) }

      # Create SDK file
      sdk_file_path = "#{daemon_dir}/config/meducation-sdk.yml"
      sdk_file = <<-EOS
development:
  access_id: #{daemon_name.camelize}
  secret_key: 'foobar'

production:
  access_id: #{daemon_name.camelize}
      EOS
      File.open(sdk_file_path, "w") { |f| f.write(sdk_file) }
    end
  end
end
