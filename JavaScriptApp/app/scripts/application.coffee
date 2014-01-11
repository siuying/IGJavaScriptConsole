class JavaScriptProcessor
  evaulate: (source, success, failure) ->
    try
      result = eval(source)
      success(result)
    catch e
      failure(e)

class CoffeeScriptProcessor extends JavaScriptProcessor
  evaulate: (source, success, failure) ->
    try
      result = CoffeeScript.eval(source)
      success(result)
    catch e
      failure(e)

class WebSocketProcessor
  constructor: (address) ->
    @ws = new WebSocket(address)

    @ws.onopen = =>
      console.log 'opened'

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

  evaulate: (source, success, failure) ->
    message =
      command: 'eval'
      source: source
    command = JSON.stringify(message)
    @success = success
    @failure = failure
    @ws.send(command)

class ConsoleController
  constructor: ->
    @jsConsole = $('#console').jqconsole("Hi!\n", '> ')
    @compiler = new WebSocketProcessor('ws://localhost:3300/context')

  prompt: ->
    @jsConsole.Prompt true, (input) =>
      success = (result) =>
        @jsConsole.Write(result + '\n', 'jqconsole-output')  
        @prompt()
      failure = (error) =>
        @jsConsole.Write(error + '\n', 'jqconsole-error')  
        @prompt()
      @compiler.evaulate(input, success, failure)

module.exports = ->
  controller = new ConsoleController
  controller.prompt()