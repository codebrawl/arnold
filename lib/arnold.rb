require 'tempfile'

module Arnold

  def edit
    YAML.load(change).each { |key, value| write_attribute(key, value) }
  end

  def edit!
    edit
    save!
  end

  private

    def change
      path = tempfile
      system [editor, path].join(' ')
      File.read(path)
    end

    def tempfile
      tmp = Tempfile.new(id.to_s)
      File.open(tmp.path, 'w') { |file| file.write(attributes.to_yaml) }
      tmp.path
    end

    def editor
      editor = ENV['EDITOR'] || 'vi'
      [editor, editor_extra_options[editor]].compact.join(' ')
    end
    
    def editor_extra_options
      { "mate" => "-w", "subl" => "-w" }
    end
end

Mongoid::Document.send(:include, Arnold)  if defined? Mongoid::Document
ActiveRecord::Base.send(:include, Arnold) if defined? ActiveRecord::Base
