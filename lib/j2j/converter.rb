require 'json'
require 'pry'

require_relative './configurator'
require_relative './field_details'


@java_classes = {}
@java_fields = {}
@java_lists = {}
@field_info = {}

##
## GET JAVA TYPES
##
def get_java_type(value, field_details, key)
  field_details.write_class_file = false
  java_type = @config.unknown_class

  if value.is_a?(Fixnum)
    java_type = "Long"
  elsif value.is_a?(Float)
    java_type = "Double"
  elsif value.is_a?(Array)
    inner_value = get_java_type(value[0], field_details, key)
    if inner_value == @config.unknown_class
      inner_value = to_java_class_name(key)
      if @do_chop
        inner_value.chop!
      end
      inner_value = add_class_prefix_and_suffix(inner_value)
      setup_data(value[0], key)
      field_details.write_class_file = true
    end
    java_type = "List<" + inner_value + ">"
  elsif value.is_a?(String)
    java_type = "String"
  elsif value.is_a?(TrueClass) || value.is_a?(FalseClass)
    java_type = "Boolean"
  end
  return java_type;
end


##
## PROCESS ARRAY
##
def process_array(value, field_details, key, parent)
  field_details.type = "Array"
  @java_classes[key] = parent
  @java_lists[key] = parent
  if value[0].is_a?(Hash)
    setup_data(value[0], key)
  else
    field_details.array_type = get_java_type(value[0], field_details, key)
  end
end


##
## SETUP THE DATA
##
def setup_data(hash, parent)
  @java_fields[parent] = []
  hash.each do |key,value|
    field_details = FieldDetails.new
    field_details.field_name = key
    field_details.parent = parent
    field_details.write_class_file = true
    if value.is_a?(Array)
      process_array(value, field_details, key, parent)
    elsif value.is_a?(Hash)
      @java_classes[key] = parent
      field_details.type = "Hash"
      setup_data(value, key)
    else
      field_details.type = get_java_type(value, field_details, key)
    end
    @field_info[key] = field_details
    @java_fields[parent] = @java_fields[parent] + [ key ]
  end

end



##
## TO JAVA CLASS NAME
##
def to_java_class_name(class_name)
  java_class_name = ""
  separator = false
  first = true
  class_name.each_char do |c|
    if separator or first
      java_class_name = java_class_name + c.to_s.upcase
      separator = false
      first = false
    else
      case c
        when '-'
        when '_'
          separator = true
        else
          java_class_name = java_class_name + c
      end
    end
  end

  return java_class_name
end



##
## TO JAVA FIELD NAME
##
def to_java_field_name(field_name)
  java_field_name = ""
  separator = false
  first = true
  leave_lowercase = false
  if @config.field_prefix != ""
    field_name = @config.field_prefix + "_" + field_name
  end
  if @config.field_suffix != ""
    field_name = field_name + "_" + @config.field_suffix
  end
  field_name.each_char do |c|
    if separator
      if leave_lowercase
        java_field_name = java_field_name + c
      else
        java_field_name = java_field_name + c.to_s.upcase
      end
      separator = false
    else
      case c
        when '-'
        when '_'
            separator = true
            leave_lowercase = false
            if first
              leave_lowercase = true
            end
        else
          java_field_name = java_field_name + c
      end
    end
    first = false
  end

  return java_field_name
end



##
## TO JAVA METHOD NAME
##
def to_java_method_name(field_name)
  java_method_name = ""
  separator = false
  first = true
  field_name.each_char do |c|
    if separator
      java_method_name = java_method_name + c.to_s.upcase
      separator = false
    else
      case c
        when '-'
        when '_'
            separator = true
        else
          if first
            java_method_name = java_method_name + c.to_s.upcase
          else
            java_method_name = java_method_name + c
          end
      end
    end
    first = false
  end

  return java_method_name
end


##
## WRITE FILE
##
def write_file(value)

  if value
    return value.write_class_file
  end
  return true
end


##
## ADD CLASS PREFIX AND SUFFIX
##
def add_class_prefix_and_suffix(class_name)
  if class_name == "String" || class_name == "Double" || class_name == "Long" || class_name == "Boolean"
    return class_name
  end
  if @config.class_prefix != ""
    class_name = @config.class_prefix + class_name
  end
  if @config.class_suffix != ""
    class_name = class_name + @config.class_suffix
  end
  return class_name
end


##
## JAVA CLASS TO BE OUTPUTED
##
def java_class_output(class_name, parent)

  proper_class_name = to_java_class_name(class_name)
  if @java_lists[class_name]
    proper_class_name.chop! if @do_chop
  end
  if class_name != @config.top_level_class
    proper_class_name = add_class_prefix_and_suffix(proper_class_name)
  end

  field_list = ""
  list_import = ""
  json_property_import = ""
  json_serialize_import = ""
  getters_and_setters = ""

  if @java_fields[class_name]
    @java_fields[class_name].each do |field|
      field_type = @field_info[field].type
      method_name = to_java_method_name(field)
      method_name = add_class_prefix_and_suffix(method_name)
      java_field = to_java_field_name(field)
      if @java_fields[field]
        field_type = to_java_class_name(field)
        method_name = to_java_method_name(field_type)
        method_name = add_class_prefix_and_suffix(method_name)
      end
      if (@java_lists[field] and @java_lists[field] == class_name)
        if @field_info[field].array_type
          field_type = @field_info[field].array_type
        elsif @do_chop
          field_type.chop!
        end
        field_type = add_class_prefix_and_suffix(field_type)
        field_type = "List<#{field_type}>"
        list_import = "import java.util.List;"
      else
        field_type = add_class_prefix_and_suffix(field_type)
      end
      json_annotation = ""
      if java_field != field
        json_property_import = @config.json_property_import
        json_annotation = "  @SerializedName(\"#{field}\")\n"
        if field == '_rev' or field == '_id'
          json_annotation = json_annotation + "  @JsonSerialize(include = Inclusion.NON_EMPTY)\n"
          json_serialize_import = @config.json_serialize_import
        end
      end
      field_list = field_list + json_annotation + "  private #{field_type} #{java_field};\n"
      getters_and_setters = getters_and_setters + <<GS

  public #{field_type} get#{method_name}() {
    return #{java_field};
  }

  public void set#{method_name}(#{field_type} #{java_field}) {
    this.#{java_field} = #{java_field};
  }
GS
    end
  end

  doc = <<JCO
#{@java_class_header}
package #@package;

#{list_import}
#{json_property_import}
#{json_serialize_import}

/**
 * Created with cesarferreira/j2j
 */
public class #{proper_class_name} \{

#{field_list}
#{getters_and_setters}
\}
JCO

  Dir.mkdir(@config.output_directory) if !File.exists?(@config.output_directory)

  if !File.directory?(@config.output_directory)
    puts "#{@config.output_directory} is not a directory!"
    exit -1
  end

  # don't write java file files "primitive" array/list fields
  if write_file(@field_info[class_name]) == true
    File.open("#{@config.output_directory}/#{proper_class_name}.java", 'w') {|f| f.write(doc) }
  end

end


##
## PARSE THE INCOMING PARAMS
##
def parse_args(path, params)

  @config.json_file = path
  @config.package = params[:package]
  @config.top_level_class = params[:root_class].gsub(/.java/,'')
  @config.output_directory  = params[:output]

end

##
## DO THE ACTUAL CONVERTING
##
def convert(path, options)

  @java_classes = {}
  @java_fields = {}
  @java_lists = {}
  @field_info = {}

  @do_chop = true
  @config = Configurator.new

  parse_args(path, options)

  puts "Using JSON file: #{@config.json_file.green}"
  puts "Using Java package: #{@config.package.green}"
  puts "Using Java top level class: #{@config.top_level_class.green}"
  puts "Using output directory: #{@config.output_directory.green}"

  @package = @config.package

  if !File.exists?(@config.json_file)
    puts "JSON file: #{@config.json_file} does not exist!"
    puts "Try -h flag for help"
    exit -1
  end

  json_file_contents = IO.read(@config.json_file)
  json = JSON.parse(json_file_contents)

  @java_classes[@config.top_level_class] = "TOP_LEVEL_CLASS"
  setup_data(json, @config.top_level_class)
  @java_classes.each { |class_name,parent| java_class_output(class_name, parent) }

end
