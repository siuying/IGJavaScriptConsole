# IGJavaScriptConsole

A JavaScript/Ruby REPL for your Objective-C apps.

![http://f.cl.ly/items/2I3v1c0T001E2K1i1l2l/console.gif](http://f.cl.ly/items/2I3v1c0T001E2K1i1l2l/console.gif)

## Why?

With iOS 7 shipped with JavaScriptCore, we can now run Opal (a JavaScript 
based ruby implementation) on iOS to extend the app dynamically.

Theres one major problem however, to compile the Ruby to JavaScript,
then compile the app, install it and run takes a lot of time. What
if we have a REPL that let us dynamically define and run Ruby code and 
run on device or simulator in realtime?

## Implementation

- JavaScriptCoreOpalAdditions Load Opal into JavaScriptCore, and some 
additions specifically for iOS.
- jqConsole Web based terminal.
- ACE Editor Web based code editor with syntax highlighting.
- CocoaHTTPServer HTTP and WebSocket server for realtime communication 
between iOS and desktop.

## Installation

Add following lines to your ``Podfile``:

```ruby
pod 'IGJavaScriptConsole'
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