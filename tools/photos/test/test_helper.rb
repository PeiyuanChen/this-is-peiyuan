require "minitest/autorun"
require "fileutils"
require "tmpdir"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

FIXTURE_RESOURCES = File.expand_path("../../../test/resources", __dir__)

def fixture_photo(name)
  File.join(FIXTURE_RESOURCES, "#{name}.JPG")
end
