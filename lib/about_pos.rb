
class About_Pos

  No_Next = Class.new(RuntimeError)
  No_Prev = Class.new(RuntimeError)

  class << self

    def Back arr
      size = arr.size
      arr.reverse.each_with_index { |v, i|

        real_index = (size - 1) - i

        meta = Meta.new(:back, real_index, i, arr)
        meta.fin

        yield meta.value, meta.real_index, meta
      }
    end

    def Forward arr
      size = arr.size
      arr.each_with_index { |v, i|
        real_index = i

        meta = Meta.new(:forward, real_index, i, arr)
        meta.fin

        yield meta.value, meta.real_index, meta
      }
    end

  end # === class self ===

  class Meta

    class << self
      def new *args
        o = super(*args)
        if o.invalid?
          nil
        else
          o
        end
      end
    end # === class self ===

    def initialize dir, real_index, i, arr, move = nil
      @invalid = false
      @arr = arr
      @is_fin = false
      @data   = {}
      @dir    = dir
      @last_index = arr.size - 1
      @next = nil
      @prev = nil

      case move

      when :next
        if forward?
          if @last_index == real_index
            invalid!
            return nil
          else
            @real_index = real_index + 1
            @value      = @arr[@real_index]
            @i          = i + 1
          end

        else
        end

      when :prev
        if forward?
        else
        end

      else
        @real_index = real_index
        @value  = nil
        @i      = i

        @next   = Meta.new(@dir, @real_index, @i, arr, :next)
        @prev   = Meta.new(@dir, @real_index, @i, arr, :prev)
      end
    end

    def invalid?
      @invalid
    end

    def invalid!
      @invalid = true
    end

    [
      :real_index,
      :last_index,
      :value, :i,
      :next, :prev
    ].each { |v|
      eval %~
        def #{v}
          raise "Value not set for: #{v}" if @#{v}.nil?
          @#{v}
        end

        def #{v}= o
          raise "No more values can be set after .fin is called" if @is_fin
          @#{v} = o
          return o
        end
      ~
    }

    def next
      @msg ||= if forward?
                 "This is the first position."
               else
                 "This is the last position."
               end
      raise No_Next, @msg if !next?
      raise "Value not set for: next" if @next.nil?
      @next
    end

    def prev
      @msg ||= if forward?
                 "This is the first position."
               else
                 "This is the last position."
               end
      raise No_Prev, @msg if !prev?
      raise "Value not set for: prev" if @prev.nil?
      @prev
    end

    def dir
      @dir
    end

    def back?
      dir == :back
    end

    def forward?
      dir == :forward
    end

    def next?
      if forward?
        real_index != last_index
      else
        real_index != 0
      end
    end

    def prev?
      if forward?
        real_index != 0
      else
        real_index != last_index
      end
    end

    def fin
      @is_fin = true
      self
    end

    def top?
      real_index == 0
    end

    def middle?
      real_index != 0 && real_index != last_index
    end

    def bottom?
      real_index == last_index
    end

    def [] k
      @data[k]
    end

    def []= k, v
      @data[k] = v
    end

  end # === class Meta ===


end # === class About_Pos ===
