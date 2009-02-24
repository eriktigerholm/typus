module AdminTableHelper

  ##
  # All helpers related to table.
  #
  def build_typus_table(model, fields, items, link_options = { } )

    returning(String.new) do |html|

      html << <<-HTML
<table>
      HTML

      html << typus_table_header(model, fields)

      items.each do |item|

        html << <<-HTML
<tr class="#{cycle('even', 'odd')}" id="item_#{item.id}">
        HTML

        fields.each do |key, value|
          case value
          when :boolean:           html << typus_table_boolean_field(key, item)
          when :datetime:          html << typus_table_datetime_field(key, item)
          when :date:              html << typus_table_datetime_field(key, item)
          when :time:              html << typus_table_datetime_field(key, item)
          when :belongs_to:        html << typus_table_belongs_to_field(key, item)
          when :tree:              html << typus_table_tree_field(key, item)
          when :position:          html << typus_table_position_field(key, item)
          when :has_and_belongs_to_many:
            html << typus_table_has_and_belongs_to_many_field(key, item)
          else
            html << typus_table_string_field(key, item, fields.first.first, link_options)
          end
        end

      ##
      # This controls the action to perform. If we are on a model list we 
      # will remove the entry, but if we inside a model we will remove the 
      # relationship between the models.
      #
      # Only shown is the user can destroy items.
      #

      if @current_user.can_perform?(model, 'delete')

        case params[:action]
        when 'index'
          perform = link_to image_tag('admin/trash.gif'), { :action => 'destroy', 
                                                            :id => item.id }, 
                                                            :confirm => 'Remove entry?', 
                                                            :method => :delete
        else
          perform = link_to image_tag('admin/trash.gif'), { :action => 'unrelate', 
                                                            :id => params[:id], 
                                                            :resource => item.class.name.tableize, 
                                                            :resource_id => item.id }, 
                                                            :confirm => "Unrelate #{model.name.humanize.singularize} from #{@resource[:class_name]}?"
        end

      end

      html << <<-HTML
<td width="10px">#{perform}</td>
</tr>
      HTML

    end

      html << "</table>"

    end

  end

  ##
  # Header of the table
  #
  def typus_table_header(model, fields)
    returning(String.new) do |html|
      headers = []
      fields.each do |key, value|
        order_by = model.reflect_on_association(key.to_sym).primary_key_name rescue key
        sort_order = (params[:sort_order] == 'asc') ? 'desc' : 'asc'
        if (model.model_fields.map(&:first).collect { |i| i.to_s }.include?(key) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(key.to_sym)) && params[:action] == 'index'
          headers << <<-HTML
<th>#{link_to "<div class=\"#{sort_order}\">#{t(key.humanize)}</div>", { :params => params.merge(:order_by => order_by, :sort_order => sort_order) }}</th>
          HTML
        else
          headers << <<-HTML
<th>#{t(key.humanize)}</th>
          HTML
        end
      end
      headers << "<th>&nbsp;</th>"
      html << <<-HTML
<tr>
#{headers.join("\n")}
</tr>
      HTML
    end
  end

  def typus_table_belongs_to_field(attribute, item)
    if item.send(attribute).kind_of?(NilClass)
      "<td></td>"
    else
      "<td>#{link_to item.send(attribute).typus_name, :controller => attribute.pluralize, :action => 'edit', :id => item.send(attribute).id}</td>"
    end
  end

  def typus_table_has_and_belongs_to_many_field(attribute, item)
    <<-HTML
<td>#{item.send(attribute).map { |i| i.typus_name }.join('<br />')}</td>
    HTML
  end

  ##
  # When detection of the attributes is made a default attribute 
  # type is set. From the string_field we display other content 
  # types.
  #
  def typus_table_string_field(attribute, item, first_field, link_options = {})
    returning(String.new) do |html|
      if first_field == attribute
        html << <<-HTML
<td>#{link_to item.send(attribute) || @resource[:class].typus_options_for(:nil), link_options.merge(:controller => item.class.name.tableize, :action => 'edit', :id => item.id)}</td>
        HTML
      else
        html << <<-HTML
<td>#{item.send(attribute)}</td>
        HTML
      end
    end
  end

  def typus_table_tree_field(attribute, item)
    <<-HTML
<td>#{item.parent.typus_name if item.parent}</td>
    HTML
  end

  def typus_table_position_field(attribute, item)
    returning(String.new) do |html|
      html_position = [["Up", "move_higher"], ["Down", "move_lower"]].map do |position|
                        <<-HTML
#{link_to t(position.first), :params => params.merge(:controller => item.class.name.tableize, :action => 'position', :id => item.id, :go => position.last)}
                        HTML
                      end
      html << <<-HTML
<td>#{html_position.join('/ ')}</td>
      HTML
    end
  end

  def typus_table_datetime_field(attribute, item)

    date_format = item.class.typus_date_format(attribute)

    returning(String.new) do |html|
      html << <<-HTML
<td>#{!item.send(attribute).nil? ? item.send(attribute).to_s(date_format) : @resource[:class].typus_options_for(:nil)}</td>
      HTML
    end

  end

  def typus_table_boolean_field(attribute, item)

    boolean_icon = @resource[:class].typus_options_for(:icon_on_boolean)
    boolean_hash = @resource[:class].typus_boolean(attribute)

    unless item.send(attribute).nil?
      status = item.send(attribute)
      content = (boolean_icon) ? image_tag("admin/status_#{status}.gif") : boolean_hash["#{status}".to_sym]
    else
      # Content is nil, so we show nil.
      content = @resource[:class].typus_options_for(:nil)
    end

    returning(String.new) do |html|

      if @resource[:class].typus_options_for(:toggle) && !item.send(attribute).nil?
        html << <<-HTML
<td align="center">
  #{link_to content, {:params => params.merge(:controller => item.class.name.tableize, :action => 'toggle', :field => attribute, :id => item.id)} , :confirm => "Change #{attribute.humanize.downcase}?"}
</td>
        HTML
      else
        html << <<-HTML
<td align="center">
  #{content}
</td>
        HTML
      end

    end

  end

end