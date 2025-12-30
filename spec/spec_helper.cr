require "spec"
require "vcr"
require "../src/monobank_api"

VCR.configure do |settings|
  settings.cassette_library_dir = File.join(__DIR__, "cassettes")
  settings.filter_sensitive_data["X-Token"] = "<TOKEN>"
end
