class JavaScriptConfig
  # console - jqconsole object
  # editor - ace editor object
  @config: (console, editor) ->
    console.SetIndentWidth(4)
    console.RegisterMatching '(', ')'
    console.RegisterMatching '[', ']'
    console.RegisterMatching '{', '}'

    editor.getSession().setMode("ace/mode/javascript")
    editor.getSession().setTabSize(4)
    editor.getSession().setUseSoftTabs(true)

  @multiLineCallback: (command) ->
    # no multiline support at the moment
    return false

  @webSocketUrl: (base) ->
    base + "/eval/javascript"

module.exports = JavaScriptConfig