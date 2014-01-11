# adapted from https://github.com/replit/jsrepl/blob/master/langs/ruby/jsrepl_ruby.coffee
# provide some basic indentation in the console.
class ConsoleMultilineHandler
  constructor: (language) ->
    @language = language

  multiLineCallback: (command) =>
    if @language == 'ruby'
      @rubyMultiLineCallback(command)
    else
      false

  rubyMultiLineCallback: (command) ->
    levels = 0
    parens = 0
    braces = 0
    brackets = 0
    last_line_changes = 0
    for line in command.split '\n'
      last_line_changes = 0
      for token in (line.match(TOKENS) or [])
        if token in BLOCK_OPENERS
          levels++
          last_line_changes++
        else if token is '('
          parens++
          last_line_changes++
        else if token is '{'
          braces++
          last_line_changes++
        else if token is '['
          brackets++
          last_line_changes++
        else if token is 'end'
          levels--
          last_line_changes--
        else if token is ')'
          parens--
          last_line_changes--
        else if token is ']'
          braces--
          last_line_changes--
        else if token is '}'
          brackets--
          last_line_changes--

        if levels < 0 or parens < 0 or braces < 0 or brackets < 0
          return false

    if levels > 0 or parens > 0 or braces > 0 or brackets > 0
      return if last_line_changes > 0 then last_line_changes else 0
    else
      return false

BLOCK_OPENERS = [
  "begin"
  "module"
  "def"
  "class"
  "if"
  "unless"
  "case"
  "for"
  "while"
  "until"
  "do"
]

TOKENS = ///
\s+
|\d+(?:\.\d*)?
|"(?:[^"]|\\.)*"
|'(?:[^']|\\.)*'
|/(?:[^/]|\\.)*/
|[-+/*]
|[<>=]=?
|:?[a-z@$][\w?!]*
|[{}()\[\]]
|[^\w\s]+
///ig

module.exports = ConsoleMultilineHandler