# Ruby-GPIO

A Ruby DSL to interface with the Raspberry Pi GPIO. It wraps around the Linux sysfs-based GPIO interface and provides features to set pins as input or output, pull pins to high or low, and also to asynchronously watch for changes to a pin, then trigger a handler to react to it.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-gpio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-gpio

## Usage

Example:

```ruby
require 'ruby-gpio'

# blue, yellow and led are labels, 22, 23 and 27 are GPIO pin numbers
GPIO.access(blue: 23, yellow: 27, led: 22) do
  blue.as :in # set pin GPIO23, labeled blue, as an input pin
  yellow.as :in
  led.as :out

  # watch GPIO23 and turn the led on when it is set to high
  # use async to watch the pin asynchronously
  blue.async.watch_for(1) do
    led.on
  end
  # watch GPIO27 and turn the led off when it is set to high
  yellow.async.watch_for(1) do
    led.off
  end
  
  # sleep is only necessary if you're watching pins
  sleep
end
```

## Contributing

1. Fork it ( https://github.com/sausheong/ruby-gpio/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
