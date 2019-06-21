class RenderTemplate_
  def initialize(types, data, selected)
    @types = types
    @data = data
    @selected = selected
  end
end

filename = File.expand_path("../../views/index.html", __FILE__) 
erb = ERB.new(File.read(filename))
erb.filename = filename

RenderTemplate = erb.def_class(RenderTemplate_, 'render()')
