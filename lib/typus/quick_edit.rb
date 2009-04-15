module Typus

  module QuickEdit

    def quick_edit

      render :text => '' and return unless session[:typus_user_id]

      url = url_for :controller => "admin/#{params[:resource]}", 
                    :action => 'edit', 
                    :id => params[:id]

      @content = <<-HTML
  var links = '';
  links += '<div id="quick_edit">';
  links += '<a href=\"#{url}\">#{params[:message]}</a>';
  links += '</div>';
  links += '<style type="text/css">';
  links += '<!--';
  links += '#quick_edit { font-size: 11px; float: right; position: fixed; right: 0px; background: #{params[:color]}; margin: 5px; padding: 3px 5px; }';
  links += '#quick_edit a { color: #FFF; font-weight: bold; }'
  links += '-->';
  links += '</style>';
  document.write(links);
        HTML

      render :text => @content

    end

  end

end