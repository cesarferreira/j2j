#
# Set default values here, some can be overridden on command line
#
class Configurator
  attr_accessor :package, :json_file, :top_level_class,
                :output_directory,
                :unknown_class,
                :ignore_unknown_properties_annotation, :ignore_unknown_properties_import,
                :json_property_import, :json_serialize_import,
                :field_suffix, :field_prefix,
                :class_suffix, :class_prefix

  def initialize

    # If types cannot be inferred from example json, they will be represented with Object unless overridden.
    # In which case, UNKNOWN will be used. This will prohibit the class from compiling.
    self.unknown_class = "Object"

    #
    # Annotations and imports to put in the Java code based on Jackson.
    # If you want pure POJOs with no annotations, empty these properties.
    #
    # self.ignore_unknown_properties_annotation = "@JsonIgnoreProperties(ignoreUnknown = true)"
    # self.ignore_unknown_properties_import = "import org.codehaus.jackson.annotate.JsonIgnoreProperties;"


    self.json_property_import = "import java.util.date;"
    self.json_serialize_import = "import com.google.gson.annotations.SerializedName;"


    self.field_suffix = ""
    self.field_prefix = ""
    self.class_suffix = ""
    self.class_prefix = ""
  end
end
