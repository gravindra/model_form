module ModelForm
  # takes ActiveRecord object
  CONFIG_FILE = "/config/model_form_config.yml"

  def model_form resource
    simple_form_for resource do |f|
      visible_fields(resource).each {|attr_name| concat f.input(attr_name) }
        concat f.button(:submit)
        concat cancel_link(resource)
    end
  end

  def visible_fields resource
    resource.attribute_names - ignored_attributes(resource)
  end

  def cancel_link resource
    link_to 'cancel', send(resource.model_name.collection + '_path')
  end

  def ignored_attributes resource
    config = load_config_file
    global_config(resource, config) + model_config(resource, config)
  end

  def global_config resource, config
    config.fetch("global_ignored_attributes", [])
  end

  def model_config resource, config
    config[resource.class.to_s]["ignored_attributes"] || []
  end

  def load_config_file
    YAML.load_file("#{Rails.root}#{CONFIG_FILE}")
  end

  ActionView::Base.send :include, ModelForm
end
