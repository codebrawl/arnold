require 'tempfile'

module Arnold

  def update
    YAML.load(change).each { |key, value| write_attribute(key, value) }
  end

  private

    def change
      path = tempfile
      system "vi #{path}"
      File.read(path)
    end

    def tempfile
      tmp = Tempfile.new(id.to_s)
      File.open(tmp, 'w') { |file| file.write(attributes.to_yaml) }
      tmp.path
    end

end

Mongoid::Document.send(:include, Arnold) if defined? Mongoid::Document
