class StaticObject

  def initialize(entry)
    @entry = entry
    @template_names = Dir.glob("source/templates/**/*").collect{|tpl| File.basename(tpl, ".html.erb") }
  end

  def path
    if File.extname(@entry.path) == ''
      "/#{@entry.path}/index.html"
    else
      "/#{@entry.path}"
    end
  end

  def template
    filename = @template_names.include?(@entry.template) ? @entry.template : 'default'
    "/templates/#{filename}.html"
  end

  def in_nav?
    @entry.try(:header_nav)
  end

  def nav_name
    @entry.send(:nav_name)
  rescue
    @entry.title
  end

  def method_missing(method, *args, &block)
    if @entry.fields.keys.include?(method.to_sym)
      @entry.send(method.to_sym)
    else
      super
    end
  end

end
