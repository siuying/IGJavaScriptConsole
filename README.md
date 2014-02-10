# IGJavaScriptConsole

A JavaScript/Ruby REPL for your Objective-C apps.

![http://f.cl.ly/items/2I3v1c0T001E2K1i1l2l/console.gif](http://f.cl.ly/items/2I3v1c0T001E2K1i1l2l/console.gif)

Check [the blog post](http://reality.hk/posts/2014/01/12/building-a-ios-ruby-repl/) for more details.

## Why?

With iOS 7 shipped with JavaScriptCore, we can now run Opal (a JavaScript 
based ruby implementation) on iOS to extend the app dynamically.

Theres one major problem however, to compile the Ruby to JavaScript,
then compile the app, install it and run takes a lot of time. What
if we have a REPL that let us dynamically define and run Ruby code and 
run on device or simulator in realtime?

## Implementation

- [Opal](http://opalrb.org/) A Ruby to JavaScript compiler. It even come with sprockets extension which lets you bundle the compiled script easily.
- [JavaScriptCoreOpalAdditions](https://github.com/siuying/JavaScriptCoreOpalAdditions) A thin layer of Objective-C that load and provides native features to Opal.
- [jqConsole](https://github.com/replit/jq-console) Web based terminal.
- [Ace](http://ace.c9.io/) Web based code editor with syntax highlighting.
- [CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer) HTTP and WebSocket server for realtime communication 
between iOS and desktop.

## Installation

Add following lines to your ``Podfile``:

```ruby
pod 'IGJavaScriptConsole', '~> 0.1.1'
```

## Usage

To start a console, create a server by supply a JSContext and language.

```objective-c
#import "IGJavaScriptConsoleServer.h"

NSError* error;
self.server = [[IGJavaScriptConsoleServer alloc] initWithContext:context
                                                        language:IGJavaScriptConsoleServerLanguageRuby];
self.server.port = 3300;
if (![self.server start:&error]) {
    DDLogError(@"error: %@", error);
}
```

Connect your browser to your device at 3300 port (e.g. http://localhost:3300)
to connect to the console.

## License

MIT License. See License.txt.