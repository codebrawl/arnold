require 'rbconfig'

module Arnold
  module Utils
    def self.windows?
      Config::CONFIG['host_os'] =~ /mswin|mingw/
    end
  end
end