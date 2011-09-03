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
      swap_yamler{ injection(data).to_yaml }
    end

    def self.deyamlize(data)
      swap_yamler{ YAML.load data }
    end

    def self.swap_yamler(&block)
      old_yamler, YAML::ENGINE.yamler = YAML::ENGINE.yamler, 'syck' if defined?(YAML::ENGINE)
      yield
    ensure
      YAML::ENGINE.yamler = old_yamler if defined?(YAML::ENGINE)
    end

    private

    def self.injection(data)
      iter = case data
        when Hash then data.each_value
        when Array then data
        else return
      end

      if iter.map{ |v| Array === v or Hash === v }.include? true
        iter.each{ |v| injection(v) if Array === v or Hash === v }
      elsif not Hash === data
        class << data
          def to_yaml_style; :inline; end
        end
      end

      data
    end
  end

  def edit(*fields)
    YAMLizer.deyamlize(change fields).each { |key, value| write_attribute(key, value) }
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

        file.write YAMLizer.yamlize(wanted_attributes)
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
      attributes.reject do |key, value|
        %w{ _id id created_at updated_at }.include? key
      end
    end
end

Mongoid::Document.send(:include, Arnold)  if defined? Mongoid::Document
ActiveRecord::Base.send(:include, Arnold) if defined? ActiveRecord::Base
