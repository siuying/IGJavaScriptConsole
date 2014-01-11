# Local JavaScript console
class JavaScriptProcessor
  evaulate: (source, success, failure) ->
    try
      result = eval(source)
      success(result)
    catch e
      failure(e)

# Local javascript console
class CoffeeScriptProcessor extends JavaScriptProcessor
  evaulate: (source, success, failure) ->
    try
      result = CoffeeScript.eval(source)
      success(result)
    catch e
      failure(e)

# WebSocket console
class WebSocketProcessor
  constructor: (@onReady, websocketUrl, language='ruby') ->
    console.log "connect to websocket: #{websocketUrl}"
    @ws = new WebSocket(websocketUrl)
    @language = language

    @ws.onopen = =>
      console.log 'opened'
      @onReady()

    @ws.onmessage = (event) =>
      console.log "event", event
      data = if event.data then JSON.parse(event.data) else { status: 'error', message: 'no response'}
      if data
        if data.status == "ok"
          console.log "command: ok"
          if @success
            @success(data.result)
            @success = null

        else if data.status == "error"
          console.error("error, event=", event)
          message = if data.message then data.message else "Unknown error: #{event}"
          @failedWithMessage(message)

        else
          console.error("unknown error, event=", event)
          @failedWithMessage("unknown error: #{event}")

      else
        console.error("unexpected data format", event)
        @failedWithMessage("unexpected data format: #{event}")

    @ws.onclose = =>
      @failedWithMessage("Connection closed")

    @ws.onerror = (event) =>
      console.log "error", event
      @failedWithMessage("Unknown error: #{event}")

  failedWithMessage: (message) ->
    if @failure
      @failure(message)
      @failure = null

  evaulate: (source, success, failure) =>
    message =
      command: 'eval'
      source: source
      language: @language
    command = JSON.stringify(message)
    @success = success
    @failure = failure
    @ws.send(command)

class ConsoleController
  constructor: (websocketUrl, language) ->
    @jsConsole = $('#console').jqconsole("Connecting to #{websocketUrl}\n", '> ')
    onReady = =>
      @prompt()
    @processor = new WebSocketProcessor onReady, websocketUrl, language

  prompt: ->
    @jsConsole.Prompt true, (input) =>
      success = (result) =>
        @jsConsole.Write(result + '\n', 'jqconsole-output')  
        @prompt()
      failure = (error) =>
        @jsConsole.Write(error + '\n', 'jqconsole-error')  
        @prompt()
      @processor.evaulate(input, success, failure)

module.exports = ->
  WEBSOCKET_URL = "%%WEBSOCKET_URL%%" # should be replaced by server in runtime
  WEBSOCKET_URL = 'ws://localhost:3300/context' if WEBSOCKET_URL == "%%WEBSOCKET" + "_URL%%"
  controller = new ConsoleController(WEBSOCKET_URL, 'ruby')
  controller.prompt()