require 'pry'
require 'dotenv/load'
require 'contentful'
require 'lib/static_object'

client = Contentful::Client.new(
  space: ENV['CONTENTFUL_SPACE_ID'],
  access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
  dynamic_entries: :auto  # Enables Content Type caching.
)

ignore 'templates/*.html.erb'

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

pages = client.entries(content_type: 'page').collect{|page| StaticObject.new(page) }
pages.each do |page|
  proxy page.path, page.template, locals: { current_object: page }
end
@app.data.store(:pages, pages)

helpers do
  def top_nav
    data.instance_variable_get('@local_sources').try(:[], 'pages').select(&:in_nav?)
  end
end