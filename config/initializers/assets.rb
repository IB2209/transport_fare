# Rails.application.config.assets.version は、アセットの変更を認識させるためのもの
Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.precompile += %w( application.js application.css )
# config/initializers/assets.rb
Rails.application.config.assets.clean = true