require 'thor'
require 'colorize'
require 'j2j/converter'
require 'j2j/version'
require 'thor/group'


module J2j
  class Cli < Thor

    include Thor::Actions

    desc 'path/to/file.json', 'indicate the path to the file.json'
    class_option :root_class, :aliases => '-r', :default => 'Example.java'
    class_option :package, :aliases => '-p', :default => 'com.example'
    class_option :output, :aliases => '-o', :description => 'Output folder', :default => 'out'
    def json(path_to_json)
      convert(path_to_json, options)
    end

    # map %w[--version -v] => :__print_version
    # desc "--version, -v", "print the version"
    # def __print_version
    #   puts J2j::VERSION
    # end

  end
end
