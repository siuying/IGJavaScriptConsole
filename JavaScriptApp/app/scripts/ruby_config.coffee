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