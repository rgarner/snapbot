D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib"                         # Directory name
  # check "Gemfile"                   # File name
  # check "app/models/**/*.rb"        # Glob
  # ignore "lib/templates/*.rb"

  library "set"
  # library "rspec"
  # library "strong_json"           # Gems

  # configure_code_diagnostics(D::Ruby.strict)       # `strict` diagnostics setting
  configure_code_diagnostics(D::Ruby.lenient) # `lenient` diagnostics setting
  configure_code_diagnostics do |hash|             # You can setup everything yourself
    # lib/snapbot/reflector.rb:73:35: [error] Unsupported block params pattern, probably masgn?
    # │ Diagnostic ID: Ruby::UnsupportedSyntax
    # │
    # └       hash.each_with_object([]) do |(key, value), array|
    #                                      ~~~~~~~~~~~~~~~~~~~~~
    # This disables that ^^
    hash[D::Ruby::UnsupportedSyntax] = :information

    # lib/snapbot/diagram/renderer.rb:21:58: [error] The method cannot be called with a block
    # │ Diagnostic ID: Ruby::UnexpectedBlockGiven
    # │
    # └         IO.popen("dot -Tsvg -o #{DEFAULT_OUTPUT_FILENAME}", "w+") do |pipe|
    #   ~~~~~~~~~
    #
    # This disables that ^^ but probably a bit too much. Can we restrict to renderer.rb?
    hash[D::Ruby::UnexpectedBlockGiven] = :information
  end
end

# target :test do
#   signature "sig", "sig-private"
#
#   check "test"
#
#   # library "pathname", "set"       # Standard libraries
# end
