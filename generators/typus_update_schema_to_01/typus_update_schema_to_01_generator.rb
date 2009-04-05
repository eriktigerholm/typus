class TypusUpdateSchemaTo01Generator < Rails::Generator::Base

  def manifest

    record do |m|

      m.migration_template 'migration.rb', 'db/migrate', { :migration_file_name => 'update_typus_schema_to_01' }

      config_folder = Typus::Configuration.options[:config_folder]
      Dir["#{Typus.root}/generators/typus_update_schema_to_01/templates/config/*"].each do |f|
        base = File.basename(f)
        m.template "config/#{base}", "#{config_folder}/#{base}"
      end

    end

  end

end