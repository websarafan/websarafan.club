# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( lean.css )

#Rails.application.config.assets.prefix = '/assets'

Rails.application.config.assets.precompile << ->(paths) do
  assets_paths = paths.map { |x| Rails.root.expand_path.join(x).to_path }
  fn_check = ->(full_path) do
    assets_paths.any? { |x| full_path.starts_with? x }
  end
  ->(path) do
    if path =~ /\.(css|js|eot|ttf|swg|woff|jpg|png)\z/
      full_path = Rails.application.assets.resolve(path).to_path
      fn_check.call(full_path).tap do |res|
        puts (res ? "including asset: #{full_path}" : "excluding asset: #{full_path}")
      end
    end
  end
end.call(['vendor/assets', 'vendor/lean_assets'])

# Rails.application.config.assets.precompile << Proc.new do |path|
#   if path =~ /\.(css|js|eot|ttf|swg|woff|jpg|png)\z/
#     full_path = Rails.application.assets.resolve(path).to_path
#     app_assets_path = Rails.root.join('vendor', 'assets').to_path
#     if full_path.starts_with? app_assets_path
#       puts "including asset: " + full_path
#       true
#     else
#       puts "excluding asset: " + full_path
#       false
#     end
#   else
#     false
#   end
# end
