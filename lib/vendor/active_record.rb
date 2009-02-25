class ActiveRecord::Base

  def to_dom(*args)

    options = args.extract_options!
    display_id = new_record? ? 'new' : id

    dom = [ options[:prefix], 
            self.class.name.underscore, 
            display_id, 
            options[:suffix] ]

    return dom.compact.join('_')

  end

end