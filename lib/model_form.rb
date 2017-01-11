module ModelForm
  # takes ActiveRecord object
  def model_form resource
    simple_form_for resource do |f|
      visible_fields(resource).each {|attr_name| concat f.input(attr_name) }
        concat f.button(:submit)
        concat cancel_link(resource)
    end
  end

  def visible_fields resource
    resource.attribute_names - ['id', 'created_at', 'updated_at']
  end

  def cancel_link resource
    link_to 'cancel', send(resource.model_name.collection + '_path')
  end
end

ActionView::Base.send :include, ModelForm