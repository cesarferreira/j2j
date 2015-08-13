#
# Set default values here, some can be overridden on command line
#
class Configurator
  attr_accessor :package, :json_file, :top_level_class,
                :output_directory,
                :unknown_class,
                :json_property_import, :json_serialize_import

  def initialize

    # If types cannot be inferred from example json, they will be represented with Object unless overridden.
    # In which case, UNKNOWN will be used. This will prohibit the class from compiling.
    self.unknown_class = "Object"

    self.json_property_import = "import java.util.Date;"
    self.json_serialize_import = "import com.google.gson.annotations.SerializedName;"

  end
end
