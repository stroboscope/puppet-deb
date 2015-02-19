Puppet::Parser::Functions::newfunction(
  :scanf,
  :type => :rvalue,
  :arity => 2,
  :doc => <<-DOC
Scans a string and returns an array of one or more converted values as directed by a given format string.args
See the documenation of Ruby's String::scanf method for details about the supported formats (which
are similar but not identical to the formats used in Puppet's `sprintf` function.

This function takes two mandatory arguments: the first is the String to convert, and the second
the format String. A parameterized block may optionally be given, which is called with the result
that is produced by scanf if no block is present, the result of the block is then returned by
the function.

The result of the scan is an Array, with each sucessfully scanned and transformed value.args The scanning
stops if a scan is unsuccesful and the scanned result up to that point is returned. If there was no
succesful scan at all, the result is an empty Array. The optional code block is typically used to
assert that the scan was succesful, and either produce the same input, or perform unwrapping of
the result


      "42".scanf("%i")
      "42".scanf("%i") |$x| {
        unless $x[0] =~ Integer {
          fail "Expected a well formed integer value, got '$x[0]'"
        }
        $x[0]
      }

- since 3.7.4
- note requires `parser = future`
DOC
) do |args|
  function_fail(["scanf() is only available when parser/evaluator future is in effect"])
end
