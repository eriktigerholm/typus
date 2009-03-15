require 'test/helper'

class AdminFormHelperTest < ActiveSupport::TestCase

  include AdminFormHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionController::UrlWriter

  def test_build_form
    assert true
  end

  def test_typus_belongs_to_field

    params = { :controller => 'admin/post', :id => 1, :action => :create }
    self.expects(:params).at_least_once.returns(params)

    @current_user  = mock()
    @current_user.expects(:can_perform?).with(Post, 'create').returns(false)

    expected = <<-HTML
<li><label for="item_post">Post
    <small></small>
    </label>
<select id="item_post_id" name="item[post_id]"><option value=""></option>
<option value="1">Post#1</option>
<option value="2">Post#2</option></select></li>
    HTML

    assert_equal expected, typus_belongs_to_field('post', Comment)

  end

  def test_typus_belongs_to_field_diffrent_attribute_name

   default_url_options[:host] = 'test.host'

    params = { :controller => 'admin/post', :id => 1, :action => :create }
    self.expects(:params).at_least_once.returns(params)

    @current_user  = mock()
    @current_user.expects(:can_perform?).with(Comment, 'create').returns(true)

    expected = <<-HTML
<li><label for="item_favorite_comment">Favorite comment
    <small><a href="http://test.host/comments/new?back_to=%2Ftypus%2Fpost%2F1%2Fcreate&selected=favorite_comment_id" onclick="return confirm('Are you sure you want to leave this page?\\n\\nIf you have made any changes to the fields without clicking the Save/Update entry button, your changes will be lost\\n\\nClick OK to continue, or click Cancel to stay on this page');">Add new</a></small>
    </label>
<select id="item_favorite_comment_id" name="item[favorite_comment_id]"><option value=""></option>
<option value="1"></option>
<option value="2"></option>
<option value="3"></option>
<option value="4"></option></select></li>
    HTML
    assert_equal expected, typus_belongs_to_field('favorite_comment', Post)

  end

  def test_typus_boolean_field

    output = typus_boolean_field('test', Post)

    expected = if Rails.version == '2.2.2'
                 <<-HTML
<li><label for="item_test">Test</label>
<input id="item_test" name="item[test]" type="checkbox" value="1" /><input name="item[test]" type="hidden" value="0" /> Checked if active</li>
                 HTML
               else
                 <<-HTML
<li><label for="item_test">Test</label>
<input name="item[test]" type="hidden" value="0" /><input id="item_test" name="item[test]" type="checkbox" value="1" /> Checked if active</li>
                 HTML
               end

    assert_equal expected, output

    Post.expects(:typus_field_options_for).with(:questions).returns('test')
    output = typus_boolean_field('test', Post)
    assert_match /Test?/, output

  end

  def test_typus_date_field

    output = typus_date_field('test', {}, Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
    HTML

    assert_match expected, output

  end

  def test_typus_datetime_field

    output = typus_datetime_field('test', {}, Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
    HTML

    assert_match expected, output

  end

  def test_typus_file_field

    output = typus_file_field('asset_file_name', Post)
    expected = <<-HTML
<li><label for="item_asset_file_name">Asset</label>
<input id="item_asset" name="item[asset]" size="30" type="file" /></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_password_field

    output = typus_password_field('test', Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
<input class="text" id="item_test" name="item[test]" size="30" type="password" /></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_selector_field

    @resource = { :class => Post }
    @item = posts(:published)

    output = typus_selector_field('status')

    expected = <<-HTML
<li><label for="item_status">Status</label>
<select id="item_status"  name="item[status]">
<option value=""></option>
<option selected value="true">true</option>
<option  value="false">false</option>
<option  value="pending">pending</option>
<option  value="published">published</option>
<option  value="unpublished">unpublished</option>
</select></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_text_field

    output = typus_text_field('test', Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
<textarea class="text" cols="40" id="item_test" name="item[test]" rows="10"></textarea></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_time_field

    output = typus_time_field('test', {}, Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
    HTML

    assert_match expected, output

  end

  def test_typus_tree_field
    assert true
  end

  def test_typus_string_field

    output = typus_string_field('test', Post)
    expected = <<-HTML
<li><label for="item_test">Test <small></small></label>
<input class="text" id="item_test" name="item[test]" size="30" type="text" /></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_relationships
    assert true
  end

  def test_typus_form_has_many
    assert true
  end

  def test_typus_form_has_and_belongs_to_many
    assert true
  end

  def test_typus_template_field
    assert true
  end

  def test_attribute_disabled

    assert !attribute_disabled?('test', Post)

    Post.expects(:accessible_attributes).returns(['test'])
    assert !attribute_disabled?('test', Post)

    Post.expects(:accessible_attributes).returns(['no_test'])
    assert attribute_disabled?('test', Post)

  end

  def test_expand_tree_into_select_field
    assert true
  end

end