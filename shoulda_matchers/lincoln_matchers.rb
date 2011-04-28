Dir.glob("#{File.dirname(__FILE__)}/**/*.rb") do |file|
  require file
end

# Mix in the matchers to test case
class Test::Unit::TestCase
  include Lincoln::Matchers
  extend Lincoln::Matchers
end
