class ViewController
  include Native

  alias_native :greeting, :getGreeting
  alias_native :greeting=, :setGreeting
end

vc = ViewController.new(`App.viewController`)
vc.greeting = "Hi!"