ConsoleMultilineHandler   = require "console_multiline_handler"
WebSocketEvaulator  = require "websocket_evaulator"

class ConsoleController
  constructor: (websocketUrl, @language) ->
    @multiline = new ConsoleMultilineHandler(@language)
    @evaulator = new WebSocketEvaulator(websocketUrl, language, @onReady, @onMessage, @onError)
    @jsConsole = $('#console').jqconsole("Connecting to #{websocketUrl}\n", '> ', '..')    
    @jsConsole.SetIndentWidth(2)
    @jsConsole.RegisterMatching '(', ')'
    @jsConsole.RegisterMatching '[', ']'
    @jsConsole.RegisterMatching '{', '}'
    
  # Prompt user for input on the console
  prompt: =>
    inputCallback = (input) =>
      success = (result) =>
        @onMessage(result)
        @prompt()
      failure = (error) =>
        @onError(error)
        @prompt()
      @evaulator.evaulate(input, success, failure)
    @jsConsole.Prompt true, inputCallback, @multiline.multiLineCallback, false

  # When the evaulator is ready, it will call onReady
  onReady: =>
    @prompt()

  # When the evaulator received a message
  # message - string, the message
  onMessage: (message) =>
    @jsConsole.Write(message + '\n', 'jqconsole-output')

  # When the evaulator received an error message
  # message - string, error message
  onError: (message) =>
    @jsConsole.Write(message + '\n', 'jqconsole-error')

module.exports = ->
  WEBSOCKET_URL = "%%WEBSOCKET_URL%%" # should be replaced by server in runtime
  WEBSOCKET_URL = 'ws://localhost:3300' if WEBSOCKET_URL.match "^%%WEBSOCKET_"
  controller = new ConsoleController(WEBSOCKET_URL, 'ruby')
  controller.prompt()