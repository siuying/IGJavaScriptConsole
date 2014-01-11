class ViewController
  include Native

  alias_native :greeting, :getGreeting
  alias_native :greeting=, :setGreeting
end

ViewController.new(`viewController`).greeting