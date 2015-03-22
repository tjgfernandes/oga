module Oga
  ##
  # Thread-safe LRU cache using a Hash as the underlying storage engine.
  # Whenever the size of the cache exceeds the given limit the oldest keys are
  # removed (base on insert order).
  #
  # This class uses its own list of keys (as returned by {LRU#keys}) instead of
  # relying on `Hash#keys` as the latter allocates a new Array upon every call.
  #
  # This class doesn't use MonitorMixin due to the extra overhead it adds
  # compared to using a Mutex directly.
  #
  # Example usage:
  #
  #     cache = LRU.new(3)
  #
  #     cache[:a] = 10
  #     cache[:b] = 20
  #     cache[:c] = 30
  #     cache[:d] = 40
  #
  #     cache.keys # => [:b, :c, :d]
  #
  class LRU
    ##
    # @param [Fixnum] maximum
    #
    def initialize(maximum = 1024)
      @maximum = maximum
      @cache   = {}
      @keys    = []
      @mutex   = Mutex.new
      @owner   = Thread.current
    end

    ##
    # Returns the value of the key.
    #
    # @param [Mixed] key
    # @return [Mixed]
    #
    def [](key)
      return synchronize { @cache[key] }
    end

    ##
    # Sets the key and its value. Old keys are discarded if the LRU size exceeds
    # the limit.
    #
    # @param [Mixed] key
    # @param [Mixed] value
    #
    def []=(key, value)
      synchronize do
        @cache[key] = value

        @keys.delete(key) if @keys.include?(key)

        @keys << key

        resize
      end
    end

    ##
    # Returns a key if it exists, otherwise yields the supplied block and uses
    # its return value as the key value.
    #
    # @param [Mixed] key
    # @return [Mixed]
    #
    def get_or_set(key)
      return synchronize { self[key] ||= yield }
    end

    ##
    # @return [Array]
    #
    def keys
      return synchronize { @keys }
    end

    ##
    # @param [Mixed] key
    # @return [TrueClass|FalseClass]
    #
    def key?(key)
      return synchronize { @cache.key?(key) }
    end

    ##
    # Removes all keys from the cache.
    #
    def clear
      synchronize do
        @keys.clear
        @cache.clear
      end
    end

    ##
    # @return [Fixnum]
    #
    def size
      return synchronize { @cache.size }
    end

    alias_method :length, :size

    private

    ##
    # Yields the supplied block in a synchronized manner (if needed). This
    # method is heavily based on `MonitorMixin#mon_enter`.
    #
    def synchronize
      if @owner != Thread.current
        @mutex.synchronize do
          @owner = Thread.current

          yield
        end
      else
        yield
      end
    end

    ##
    # Removes old keys until the size of the hash no longer exceeds the maximum
    # size.
    #
    def resize
      return unless size > @maximum

      to_remove = @keys.shift(size - @maximum)

      to_remove.each { |key| @cache.delete(key) }
    end
  end # LRU
end # Oga
