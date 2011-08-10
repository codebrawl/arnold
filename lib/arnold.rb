require 'tempfile'
require 'rbconfig'

module Arnold

  module Utils
    def self.windows?
      Config::CONFIG['host_os'] =~ /mswin|mingw/
    end
  end

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
      tmp.close
      tmp.path
    end

    def editor
      editor = ENV['EDITOR'] || (Utils.windows? ? 'notepad' : 'vi')
      [editor, editor_extra_options[editor]].compact.join(' ')
    end

    def editor_extra_options
      { "mate" => "-w", "subl" => "-w" }
    end
end

module InlineYAML
  def to_yaml_style
    classes = map(&:class)
    :inline unless classes.include?(Array) || classes.include?(Hash)
  end
end

Array.send :include, InlineYAML
Mongoid::Document.send(:include, Arnold)  if defined? Mongoid::Document
ActiveRecord::Base.send(:include, Arnold) if defined? ActiveRecord::Base
