# Typus

What's **Typus**?

> Effortless admin interface for your Rails application.

You can see some screenshots on the [wiki](http://github.com/fesplugas/typus/wikis).

As Django Admin, **Typus** is designed for a "single" activity:

> Trusted users editing structured content.

Keep in mind that **Typus** doesn't try to be all the things to all 
the people but it's extensible enough to match lots of use cases. I 
started to develop it late 2005 and have been updating it to match 
all my clients sites/projects requirements.

## Installing

Install from GitHub.

    $ script/plugin install git://github.com/fesplugas/typus.git

The `typus` generator copies required assets to the public folder 
of your Rails application, creates configuration files on `config` 
folder and generates the required database migration files. Make sure to 
run `rake db:migrate` before running the generator as Typus has to connect 
to your database to detect the model attributes.

    $ script/generate typus

Once `typus` generator is run, migrate your database to create the 
required tables. (only `typus_users` table is created)

    $ rake db:migrate

And finally create the first user, to do it, start the application 
server, go to <http://0.0.0.0:3000/admin> and follow the instructions.

You can view the available tasks running:

    $ rake -T typus
    (in /Users/fesplugas/Development/typus_platform)
    rake doc:plugins:typus  # Generate documentation for the typus plugin
    rake typus:i18n         # Install simplified_translation plugin.
    rake typus:misc         # Install Paperclip, acts_as_list, acts_as_tree.
    rake typus:roles        # List current roles
    rake typus:ssl          # Intall ssl_requirement plugin.

## Plugin Configuration Options

You can overwrite the following settings.

    Typus::Configuration.options[:app_name]
    Typus::Configuration.options[:config_folder]
    Typus::Configuration.options[:email]
    Typus::Configuration.options[:ignore_missing_translations]
    Typus::Configuration.options[:prefix]
    Typus::Configuration.options[:recover_password]
    Typus::Configuration.options[:root]
    Typus::Configuration.options[:ssl]
    Typus::Configuration.options[:templates_folder]
    Typus::Configuration.options[:user_class_name]
    Typus::Configuration.options[:user_fk]

Model options.

    Typus::Configuration.options[:edit_after_create]
    Typus::Configuration.options[:end_year]
    Typus::Configuration.options[:form_rows]
    Typus::Configuration.options[:icon_on_boolean]
    Typus::Configuration.options[:minute_step]
    Typus::Configuration.options[:nil]
    Typus::Configuration.options[:per_page]
    Typus::Configuration.options[:sidebar_selector]
    Typus::Configuration.options[:start_year]
    Typus::Configuration.options[:toggle]

You can also overwrite the model options by model. This is done always 
from the yaml files under `config/typus`.

    Post:
      options:
        edit_after_create: false
        end_year: 2015
        form_rows: 25
        icon_on_boolean: true
        minute_step: 15
        nil: 'nil'
        per_page: 5
        sidebar_selector: 5
        start_year: 1990
        toggle: true

### Recover password

Recover password is disabled by default. To enable it you should 
provide an email address which will be shown as the sender.

    Typus::Configuration.options[:email] = 'typus@application.com'
    Typus::Configuration.options[:recover_password] = true

### Special Route

To overwrite the default prefix path of your application place the 
following configuration option on `development.rb`, `production.rb` 
on the `config/environments` folder.

    Typus::Configuration.options[:prefix] = "backoffice"

### View Missing Translations

If you are a developer who wants to translate Typus, add the following 
setting on `development.rb` on the `config/environments` folder so all 
missing translations messages will be shown.

    Typus::Configuration.options[:ignore_missing_translations] = false

### Disable password recover

You can disable password recover on the login page. By default, password
recovery is enabled.

    Typus::Configuration.options[:recover_password] = false

### Disallow toggle

When you have a boolean on the lists you can toggle it's status from 
true to false and false to true. You can disable this link with:

    Typus::Configuration.options[:toggle] = false

### Redirect to index after create a record

After creating a new record you'll be redirected to the record so 
you can continue editing it. If you prefer to be redirected to the 
main index you can owerwrite the setting.

    Typus::Configuration.options[:edit_after_create] = false

## Configuration file options

You can configure all **Typus** settings from the `application.yml` 
file located under the `config/typus` folder. This file is created 
once you run the `typus` generator.

### Typus Fields

    fields:
      list: name, created_at, category, status
      form: name, body, created_at, status
      relationship: name, category

NOTE: Upload files only works if you follow `Paperclip` naming 
conventions.

In form fields you can have read only fields and read only fields for 
autogenerated content. These kind of fields will be shown in the form 
but won't be editable. Example with the "name" attribute being read-only:

    fields:
      list: name, created_at, category, status
      form: name, body, created_at, status
      relationship: name, category
      options:
        read_only: name

To define `auto generated` fields.

    Order:
      fields:
        list: tracking_number, first_name, last_name
        form: tracking_number, first_name, last_name
        options:
          auto_generated: tracking_number

You can then initialize it from the model.

    ##
    # app/models/order.rb
    #
    class Order < ActiveRecord::Base

      def initialize_with_defaults(attributes = nil, &block)
        initialize_without_defaults(attributes) do
          self.tracking_number = Random.tracking_number
          yield self if block_given?
        end
      end

      alias_method_chain :initialize, :defaults

    end

You can even add "virtual fields". For example you have a model and you 
need special attributes like an slug, which is generated from the title.

    ##
    # app/models/post.rb
    #
    class Post < ActiveRecord::Base

      validates_presence_of :title

      def slug
        title.parameterize
      end

    end

You can add `slug` a as attribute and it'll be shown on the lists.

    ##
    # config/typus/application.yml
    Post:
      fields:
        list: title, slug
        form: title

### External Forms

Typus will detect automatically which kind of relationships has the model.

    relationships: users, projects

### Filters

You can define filters per model on the config file ...

    filters: status, author, created_at

### Order

Adding minus (-) sign before the attribute will make the order DESC.

    order_by: -attribute1, attribute2

### Searches

You can define search filters on `config/typus/application.yml`

    search: attribute1, attribute2

### Questions?

Sometimes on your forms you want to ask questions.

- Is highlighted?
- On newsletter?

And you can enable them with the questions option.

    Story:
      fields:
        list: title, is_highlighted
        form: title, body, is_highlighted
        options:
          questions: is_highlighted

### Selectors

Need a selector, to select gender, size, status, the encoding status 
of a video or whatever in the model? 

    Person:
      fields:
        list: ...
        form: first_name, last_name, gender, size, status
        options:
          selectors: gender, size, status

From now on the form, if you have enabled them on the list/form you'll see 
a selector with the options that you define in your model.

Example:

    ##
    # app/models/video.rb
    #
    class Video < ActiveRecord::Base

      validates_inclusion_of :status, :in => self.status

      def self.status
        %w( pending encoding encoded error published )
      end

    end

    ##
    # config/typus/application.yml
    #
    Video:
      fields:
        list: title, status
        form: title, status
        options:
          selectors: status

If the selector is not defined, you'll see a **text field** instead of a 
*select field*.

### Booleans

By default Typus will show all your booleans on the listings with an 
icon, if you prefer to show it as a text to be more verbose you can 
disable it with:

    Typus::Configuration.options[:icon_on_boolean]

Boolean text shows *True* & *False*, but you can personalize it "per 
attribute" to match your application requirements.

    ##
    # config/typus/application.yml
    #
    TypusUser:
      fields:
        list: email, status
        options:
          booleans:
            # attribute: TRUE, FALSE
            default: publicado, no_publicado
            status: active, inactive

### Date Formats

Date formats allows to define the format of the datetime field.

    ##
    # config/typus/application.yml
    #
    Post:
      fields:
        list: title, published_at
        options:
          date_formats:
            published_at: post_short

    ##
    # config/initializers/dates.rb
    #
    # Date::DATE_FORMATS[:post_short] = "%m/%Y"
    Time::DATE_FORMATS[:post_short] = "%m/%y"

### Want more actions?

    Post:
      fields:
        list: ...
        form: ...
      actions:
        index: notify_all
        edit: notify

These actions will only be available on the requested action.

You can add those actions to your admin controllers. Example:

    class Admin::NewslettersController < AdminController

      ##
      # Action to deliver emails ...
      def deliver
        ...
        redirect_to :back
      end

    end

For feedback you can use the following flash methods.

- `flash[:notice]` just some feedback.
- `flash[:error]` when there's something wrong.
- `flash[:success]` when the action successfully finished.

### Applications, modules and submodules

To group modules into an application use *application*.

    application: CMS

Each module has submodules grouped using *module*.

    module: Article

Example: (E-Commerce Application)

    Product:
      application: ECommerce
    Client:
      application: ECommerce
    Category:
      module: Product
    OptionType:
      module: Product

Example: (Blog)

    Post:
      application: Blog
    Category:
      application: Blog
    Tag:
      module: Post

## Custom Views

You can add your custom views to match your application requirements. Views 
you can customize.

    index.html.erb
    edit.html.erb
    show.html.erb

### Example

Need a custom view on the Articles listing? 

Under `app/view/admin/articles` add the file `index.html.erb` and 
Typus default `index.html.erb` will be replaced.

## Customize Interface

You can customize the interface by placing on `views/admin` the 
following files.

### Login Page

    views/admin/login/_bottom.html.erb
    views/admin/login/_top.html.erb

### Dashboard

    views/admin/dashboard/_bottom.html.erb
    views/admin/dashboard/_sidebar.html.erb
    views/admin/dashboard/_top.html.erb

### Models

    views/admin/MODEL/_edit.html.erb
    views/admin/MODEL/_edit_bottom.html.erb
    views/admin/MODEL/_edit_sidebar.html.erb
    views/admin/MODEL/_edit_top.html.erb
    views/admin/MODEL/_index.html.erb
    views/admin/MODEL/_index_bottom.html.erb
    views/admin/MODEL/_index_sidebar.html.erb
    views/admin/MODEL/_index_top.html.erb
    views/admin/MODEL/_new.html.erb
    views/admin/MODEL/_new_bottom.html.erb
    views/admin/MODEL/_new_sidebar.html.erb
    views/admin/MODEL/_new_top.html.erb
    views/admin/MODEL/_show.html.erb
    views/admin/MODEL/_show_bottom.html.erb
    views/admin/MODEL/_show_sidebar.html.erb
    views/admin/MODEL/_show_top.html.erb

Example:

    views/admin/posts/_index_top.html.erb
    views/admin/typus_users/_edit_top.html.erb

### Attribute templates

It is possible to change the presentation for a attribute 
within the form. In the example below the "published_at" 
attribute will be rendered with the template 
"app/views/admin/templates/_datepicker.html.erb". The 
resource and the attribute name will be sent as local 
variables "resource" and "attribute". You can change the 
folder with Typus::Configuration.options[:templates_folder].

    ##
    # config/typus/application.yml
    #
    Post:
      fields:
        list: title, published_at
        options:
          templates:
            published_at: datepicker

    ##
    # app/views/admin/templates/_datepicker.html.erb
    #
    <li><label><%= t(attribute.humanize) %></label>
      <%= calendar_date_select :item, attribute %>
    </li>

## Roles

Typus has roles support. You can can add as many roles as you want. 
They are defined in `config/typus/application_roles.yml` and you 
can can define the allowed actions per role.

    admin:
      TypusUser: create, read, update, delete
      Post: create, read, update, delete, rebuild
      Category: create, read, update, delete

    editor:
      Post: create, update
      Category: create, update

## Resources which are not models

Want to manage **memcached**, see the current **starling** queue or have 
an special resource which is not related to any model?

    ##
    # config/typus/application_roles.yml
    admin:
      Backup: index, download_db, download_media
      MemCached: index
      ApplicationLog: index
      Git: index, commit

When you start **Typus** a controller and a view will be created.

    app/controllers/admin/backup_controller.rb
    app/views/admin/backup/index.html

## Typus & SSL

You can use SSL on Typus. To enable it update the initializer.

    Typus::Configuration.options[:ssl] = true

Remember to install the `ssl_requirement` plugin to be able to use this 
feature.

    $ rake typus:ssl

## Tip & Tricks

### Roles for a user?

You can create a role for a user using directly the username nickname. For 
example, the user Francesc Esplugas:

    fesplugas:
      TypusUser: update
      Post: create, read, update, delete

## Testing the plugin

You need to have `mocha` to test the plugin.

    $ sudo gem install mocha

Use the following steps to test the plugin.

    $ rails typus_test
    $ cd typus_test/vendor/plugins
    $ git clone git://github.com/fesplugas/typus.git
    $ rake

By default tests are be performed against a SQLite3 database in memory.
You can also run tests against PostgreSQL and MySQL databases. You 
have to create databases, both are called `typus_test`. Once you've 
created them you can run the tests.

    $ rake DB=mysql
    $ rake DB=postgresql

## Splitting configuration files

You can split your configuration files in several files so it can be easier 
to mantain. (Files will be loaded by alphabetical order so adding 00X can 
help to load files in an special order.)

    config/typus/001-application.yml
    config/typus/002-newsletter.yml
    config/typus/003-blog.yml
    config/typus/001-application_roles.yml
    config/typus/002-newsletter_roles.yml
    config/typus/003-blog_roles.yml

## Quick edit

To enable quick edit include the AdminPublicHelper on your 
`application_helper.rb`.

    module ApplicationHelper
      include AdminPublicHelper
    end

Example:

    <%= quick_edit :resource => 'pages', 
                   :id => @page.id, 
                   :message => 'Edit this page' %>

## Acknowledgments

- Laia Gargallo (Lover and tea provider) <http://azotacalles.net>
- Isaac Feliu (Codereview) <http://www.vesne.com>
- Lluis Folch (Icons, feedback & crazy ideas) <http://wet-floor.com>

## People who has contributed to the project with patches

- Sergio Espeja <http://github.com/spejman>
- Eadz <http://github.com/eadz>
- Anthony Underwood <http://github.com/aunderwo>
- Felipe Talavera <http://github.com/flype>
- Erik Tigerholm <http://github.com/eriktigerholm>

## Author, contact, bugs, mailing list and more

- Recommend me at <http://workingwithrails.com/person/5061-francesc-esplugas>
- Browse source on GitHub <http://github.com/fesplugas/typus/tree/master>
- Visit the wiki <http://github.com/fesplugas/typus/wikis>
- Group <http://groups.google.es/group/typus>
- Report bugs <http://github.com/fesplugas/typus/wikis/bugs>

Copyright (c) 2007-2009 Francesc Esplugas Marti, released under the 
MIT license
