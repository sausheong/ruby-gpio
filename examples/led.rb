require 'ruby-gpio'

GPIO.access(blue: 23, yellow: 27, led: 22) do
  blue.as :in
  yellow.as :in
  led.as :out

  # watch GPIO23 and turn the led on when it is pulled high
  # use async to watch the pin asynchronously
  blue.async.watch_for(1) do
    led.on
  end
  # watch GPIO27 and turn the led off when it is pulled high
  yellow.async.watch_for(1) do
    white.off
  end
  
  # sleep is only necessary if you're watching pins
  sleep
end