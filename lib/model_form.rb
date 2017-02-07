module ModelForm
  # takes ActiveRecord object
  CONFIG_FILE = "/config/model_form.yml"

  def model_form resource
    simple_form_for resource do |f|
      visible_fields(resource).each {|attr_name| concat f.input(attr_name) }
        concat f.button(:submit)
        concat cancel_link(resource)
    end
  end

  def visible_fields resource
    (resource.attribute_names - ignored_attributes(resource)) | allowed_attributes(resource)
  end

  def cancel_link resource
    link_to 'cancel', send(resource.model_name.collection + '_path')
  end

  def ignored_attributes resource
    config = load_config
    (global_config(resource, config) + model_config(resource, config)).uniq
  end

  def global_config resource, config
    # config.fetch("global_ignored_attributes", [])
    config.fetch("global", {}).fetch("ignored_attributes", [])
  end

  def model_config resource, config
    config.fetch(resource.class.to_s.downcase, {}).fetch("ignored_attributes", [])
  end

  def allowed_attributes(resource)
    config = load_config
    config.fetch(resource.class.to_s.downcase, {}).fetch("allowed_attributes", [])
  end

  def load_config
    file = "#{Rails.root}#{CONFIG_FILE}"
    base_file = "../generators/templates/model_form.yml"
    if File.exists?(file)
      YAML.load_file(file)
    else
      YAML.load_file File.expand_path(base_file, __FILE__)
    end

  end

  ActionView::Base.send :include, ModelForm
end
