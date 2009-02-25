class TypusGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      # We set a default name for our application.
      application = File.basename(Dir.pwd)

      # For creating `typus.yml` and `typus_roles.yml` we need first to 
      # detect the available AR models of the application, not the plugins.
      models = Dir["#{Rails.root}/app/models/*.rb"].collect { |x| File.basename(x) }
      ar_models = []

      models.each do |model|
        class_name = model.sub(/\.rb$/,'').classify
        begin
          klass = class_name.constantize
          ar_models << klass if klass.superclass.to_s.include?('ActiveRecord::Base')
        rescue Exception => e
          puts "=> [typus] #{e.message} on `#{class_name}`."
        end
      end

      # Configuration files
      config_folder = Typus::Configuration.options[:config_folder]
      folder = "#{Rails.root}/#{config_folder}"
      Dir.mkdir(folder) unless File.directory?(folder)

      files = %w( typus.yml typus_roles.yml application.yml application_roles.yml )
      files.each do |file|
        m.template "config/typus/#{file}", 
                   "#{config_folder}/#{file}", 
                   :assigns => { :ar_models => ar_models, :application => application }
      end

      # Initializers
      m.template 'initializers/typus.rb', 
                 'config/initializers/typus.rb', 
                 :assigns => { :application => application }

      # Public folders
      [ "#{Rails.root}/public/stylesheets/admin", 
        "#{Rails.root}/public/javascripts/admin", 
        "#{Rails.root}/public/images/admin" ].each do |folder|
        Dir.mkdir(folder) unless File.directory?(folder)
      end

      m.file 'stylesheets/admin/screen.css', 'public/stylesheets/admin/screen.css'
      m.file 'stylesheets/admin/reset.css', 'public/stylesheets/admin/reset.css'
      m.file 'javascripts/admin/application.js', 'public/javascripts/admin/application.js'

      Dir["#{Rails.root}/vendor/plugins/typus/generators/typus/templates/images/admin/*"].each do |f|
        base = File.basename(f)
        m.file "images/admin/#{base}", "public/images/admin/#{base}"
      end

      # Migration files
      m.migration_template 'db/create_typus_users.rb', 
                           'db/migrate', 
                            { :migration_file_name => 'create_typus_users' }

    end

  end

end