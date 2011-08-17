require 'tempfile'
require 'rbconfig'

module Arnold

  module Utils
    def self.windows?
      Config::CONFIG['host_os'] =~ /mswin|mingw/
    end
  end

  class YAMLizer
    def self.yamlize(data)
      if defined? Psych
        yaml = Psych::Visitors::YAMLTree.new {}
        yaml << data
        set_psych_style(yaml.tree).to_yaml
      else
        data.to_yaml
      end
    end

    def self.set_psych_style(node)
      children = node.children.select(&:children)

      if children.empty?
        node.style = Psych::Nodes::Sequence::FLOW if node.children.select(&:children).empty?
      else
        children.each {|child| set_psych_style(child)}
      end

      node
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
      File.open(tmp.path, 'w') do |file|
        file.write YAMLizer.yamlize(editable_attributes)
      end
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

    def editable_attributes
      attributes.delete_if{ |k, v| %w(_id id).include?(k) }
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
