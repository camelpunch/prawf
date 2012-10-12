class ParsedLine
  class ParseError < StandardError; end

  def initialize(line)
    @line = line
  end

  def attributes
    JSON.parse(@line)
  rescue JSON::ParserError
    raise ParseError, "Invalid JSON received: #{@line}"
  rescue TypeError
  end

  def stage
    attributes && attributes['stage'] or
      raise ParseError, "Invalid instruction received: #{@line}"
  end
end

