require 'tempfile'
require 'rbconfig'

module Arnold

  module Utils
    def self.windows?
      Config::CONFIG['host_os'] =~ /mswin|mingw/
    end
  end

  def edit(*fields)
    YAML.load(change fields).each { |key, value| write_attribute(key, value) }
  end

  def edit!(*fields)
    edit(*fields)
    save!
  end

  private

    def change(fields)
      path = tempfile *fields
      system [editor, path].join(' ')
      File.read(path)
    end

    def tempfile(*fields)
      tmp = Tempfile.new(id.to_s)
      File.open(tmp.path, 'w') do |file|
        wanted_attributes = editable_attributes

        unless fields.empty?
          fields.map!(&:to_s)
          wanted_attributes.reject!{ |k, v| not fields.include?(k) }
        end

        file.write wanted_attributes.to_yaml
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
      attributes.reject { |k, v| %w(_id id).include?(k) }
    end
end

Mongoid::Document.send(:include, Arnold)  if defined? Mongoid::Document
ActiveRecord::Base.send(:include, Arnold) if defined? ActiveRecord::Base
