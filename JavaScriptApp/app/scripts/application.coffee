# evaulate with WebSocket
class WebSocketEvaulator
  constructor: (websocketUrl, language='ruby', @onReady, @onMessage, @onError) ->
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

        else if data.status == "info"
          console.info("server: ", data.message)
          @onMessage(data.message)

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
    else
      @onError(message)

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
    @processor = new WebSocketEvaulator websocketUrl, language, @onReady, @onMessage, @onError

  onReady: =>
    @prompt()

  onMessage: (message) =>
    @jsConsole.Write(message + '\n', 'jqconsole-output')

  onError: (message) =>
    @jsConsole.Write(message + '\n', 'jqconsole-error')

  prompt: ->
    @jsConsole.Prompt true, (input) =>
      success = (result) =>
        @onMessage(result)
        @prompt()
      failure = (error) =>
        @onError(error)
        @prompt()
      @processor.evaulate(input, success, failure)

module.exports = ->
  WEBSOCKET_URL = "%%WEBSOCKET_URL%%" # should be replaced by server in runtime
  WEBSOCKET_URL = 'ws://localhost:3300/context' if WEBSOCKET_URL.match "^%%WEBSOCKET_"
  controller = new ConsoleController(WEBSOCKET_URL, 'ruby')
  controller.prompt()