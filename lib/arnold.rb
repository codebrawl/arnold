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
      tmp = Tempfile.new(id)
      File.open(tmp, 'w') { |file| file.write(attributes.to_yaml) }
      tmp.path
    end

    def editor
      ENV['EDITOR'] || 'vi'
    end

end

Mongoid::Document.send(:include, Arnold) if defined? Mongoid::Document
