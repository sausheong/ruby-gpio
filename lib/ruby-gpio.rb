require "gpio/version"

require 'concurrent/async'

class Hash
  def method_missing(name, *args, &block)
    return self[name.to_sym]
  end
end


module GPIO
  class Pin
    include Concurrent::Async
    attr_accessor :name, :number, :direction

    def initialize(name, number)
      # init_mutex
      @name = name
      @number = number
    end

    # set input or output
    # gpio_num is the GPIO pin number, dir is the direction - either :out or :in
    def as(dir=:out)
      @direction = dir.to_s
      GPIO.write "gpio#{@number}/direction", @direction
    end

    # send a high value to the pin
    def on
      GPIO.write "gpio#{@number}/value", "1"
    end

    # send a low value to the pin
    def off
      GPIO.write "gpio#{@number}/value", "0"
    end

    # send a PWM (pulse width modulation) signal to the pin
    def pwm(value)
      GPIO.write "gpio#{@number}/value", value
    end    
    
    # read from the pin
    def read
      GPIO.read @number
    end

    # watch the pin for change and trigger the block once
    def watch_once_for(value, &block)
      watching = true
      while watching        
        if read == value
          GPIO.instance_eval &block
          watching = false
        end
      end
    end
    
    # watch the pin for change and trigger the block over and over again
    def watch_for(value, &block)
      while true        
        if read == value
          GPIO.instance_eval &block
        end
      end
    end

  end
  
  class << self
    # main entry for the DSL
    def access(hash, &block)
      @pins = {} # a hash of available pins
      # unexport pins before setup
      hash.each do |k, v|
        if exported?(v)
          unexport v
        end
      end
      # set up pins
      hash.each do |k, v|
        @pins[k] = Pin.new(k.to_s, v)
        export v
      end
      begin
        instance_eval &block        
      ensure        
        # make sure all pins are unexported before we end the program
        hash.each do |k, v|
          unexport v
        end
      end
    end

    # method missing used to return the pin named earlier in the hash parameter to access
    def method_missing(name, *args, &block)
      if @pins.keys.include?(name)
        return @pins[name]
      end
    end

    def export(gpio_num)
      write "export", gpio_num
    end

    def exported?(gpio_num)
      Dir.exist?("/sys/class/gpio/gpio#{gpio_num}")
    end

    def unexport(gpio_num)
      write "unexport", gpio_num
    end

    def read(gpio_num)
      File.read("/sys/class/gpio/gpio#{gpio_num}/value").to_i
    end
    
    def write(command, value)
      File.open("/sys/class/gpio/#{command}", "w") do |f|
        f.write value
      end
    end
  end
end
