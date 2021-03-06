namespace :typus do

  desc 'Install acts_as_list, acts_as_tree and paperclip.'
  task :misc do
    plugins = [ 'git://github.com/thoughtbot/paperclip.git', 
                'git://github.com/rails/acts_as_list.git', 
                'git://github.com/rails/acts_as_tree.git' ]
    system "script/plugin install #{plugins.join(' ')} --force"
  end

  desc 'Install typus_more.'
  task :more do
    plugins = [ 'git://github.com/fesplugas/typus_more.git' ]
    system "script/plugin install #{plugins.join(' ')} --force"
  end

  desc 'List current roles.'
  task :roles => :environment do
    Typus::Configuration.roles.each do |role|
      puts "\n#{role.first.capitalize} role has access to:"
      role.last.each { |key, value| puts "- #{key}: #{value}" }
    end
    puts "\n"
  end

  desc 'Install ssl_requirement.'
  task :ssl do
    plugins = [ 'git://github.com/rails/ssl_requirement.git' ]
    system "script/plugin install #{plugins.join(' ')} --force"
  end

end
