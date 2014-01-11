JavaScriptConfig   = require "javascript_config"
RubyConfig   = require "ruby_config"
WebSocketEvaulator  = require "websocket_evaulator"

class ConsoleController
  constructor: (@websocketUrl, @language) ->
    console.log("[ConsoleController] websocket: #{@websocketUrl}, language=#{@language}")
    @jqConsole = $('#console').jqconsole("Connecting to #{websocketUrl}\n", '> ', '..')    
    @editor = ace.edit("editor")
    @editor.commands.addCommand
      name: 'Evaulate'
      bindKey: {win: 'Ctrl-Enter',  mac: 'Command-Enter'}
      exec: (editor) =>
        input = editor.getValue()
        @jqConsole.Write(input + '\n', 'jqconsole-input')
        @onInput(input)
      readOnly: true
    @getConfigurator().config(@jqConsole, @editor)
    @evaulator = new WebSocketEvaulator(@getConfigurator().webSocketUrl(@websocketUrl), @onReady, @onMessage, @onError)

  setLanguage: (language) =>
    @language = language

  getLanguage: =>
    @language

  getConfigurator: =>
    if @language == 'javascript'
      return JavaScriptConfig
    else if @language == 'ruby'
      return RubyConfig
    else
      throw new Error("unsupported language: #{@language}")

  # Prompt user for input on the console
  prompt: =>
    @jqConsole.Prompt true, @onInput, @getConfigurator().multiLineCallback, false

  # When user input command
  onInput: (input) =>
    success = (result) =>
      @onMessage(result)
      @prompt()
    failure = (error) =>
      @onError(error)
      @prompt()
    @evaulator.evaulate(input, success, failure)

  # When the evaulator is ready, it will call onReady
  onReady: =>
    @prompt()

  # When the evaulator received a message
  # message - string, the message
  onMessage: (message) =>
    @jqConsole.Write(message + '\n', 'jqconsole-output')

  # When the evaulator received an error message
  # message - string, error message
  onError: (message) =>
    @jqConsole.Write(message + '\n', 'jqconsole-error')

module.exports = ->
  # should be replaced by server in runtime
  WEBSOCKET_URL = "%%WEBSOCKET_URL%%" 
  LANGUAGE = "%%LANGUAGE%%"

  # set default value in case running outside server
  WEBSOCKET_URL = 'ws://localhost:3300' if WEBSOCKET_URL.match "^%%WEBSOCKET_"
  LANGUAGE = 'ruby' if LANGUAGE.match "^%%LANGUAGE"

  controller = new ConsoleController(WEBSOCKET_URL, LANGUAGE)
  controller.prompt()