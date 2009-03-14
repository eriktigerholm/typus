require 'test/helper'

class AdminHelperTest < ActiveSupport::TestCase

  include AdminHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def test_display_link_to_previous

    output = display_link_to_previous('Post', { :action => 'edit', :back_to => '/back_to_param' })
    expected = <<-HTML
<div id="flash" class="notice">
  <p>You're updating a Post. <a href="/back_to_param">Do you want to cancel it?</a></p>
</div>
    HTML

    assert_equal expected, output

  end

  def test_remove_filter_link
    output = remove_filter_link('')
    assert output.nil?
  end

  def test_build_list
    assert true
  end

  def test_build_pagination
    assert true
  end

end