module AresMUSH  
  class TemplateRenderer
    def initialize(template)
      @template = Liquid::Template.parse(template)
    end
    
    def render(data)
      @template.render(data)
    end
    
    def self.create_from_file(file_path)
      template = File.read(file_path)
      TemplateRenderer.new(template)
    end
  end
end