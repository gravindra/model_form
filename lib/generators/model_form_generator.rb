class ModelFormGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_initializer_file
    copy_file "model_form_config.yml", "#{Rails.root}/config/model_form_config.yml"
  end

end
