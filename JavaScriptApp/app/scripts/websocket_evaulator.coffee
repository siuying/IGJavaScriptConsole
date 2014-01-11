# evaulate with WebSocket
class WebSocketEvaulator
  constructor: (websocketUrl, language='ruby', @onReady, @onMessage, @onError) ->
    console.log "connect to websocket: #{websocketUrl}"
    @ws = new WebSocket(websocketUrl + "/eval/#{language}")
    @language = language

    @ws.onopen = =>
      console.info 'connection opened'
      @onReady()

    @ws.onmessage = (event) =>
      data = if event.data then JSON.parse(event.data) else { status: 'error', message: 'no response'}
      if data
        if data.status == "ok"
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
      @failedWithMessage("Unknown error: #{event}")

  evaulate: (source, success, failure) =>
    message =
      command: 'eval'
      source: source
    command = JSON.stringify(message)
    @success = success
    @failure = failure
    @ws.send(command)

  failedWithMessage: (message) ->
    console.error(message)
    if @failure
      @failure(message)
      @failure = null
    else
      @onError(message)

module.exports = WebSocketEvaulator