class RubyConfig
  # console - jqconsole object
  # editor - ace editor object
  @config: (console, editor) ->
    console.SetIndentWidth(2)
    console.RegisterMatching '(', ')'
    console.RegisterMatching '[', ']'
    console.RegisterMatching '{', '}'

    editor.getSession().setMode("ace/mode/ruby")
    editor.getSession().setTabSize(2)
    editor.getSession().setUseSoftTabs(true)

  @multiLineCallback: (command) ->
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

  @webSocketUrl: (base) ->
    base + "/eval/ruby"

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
|\.[\w\s]+
|[^\w\s]+
///ig
module.exports = RubyConfig