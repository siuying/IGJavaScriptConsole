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

class ConsoleController
  constructor: ->
    @jsConsole = $('#console').jqconsole("Hi!\n", '> ')
    @compiler = new CoffeeScriptProcessor

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