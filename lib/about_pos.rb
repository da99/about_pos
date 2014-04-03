
class About_Pos

  No_Next = Class.new(RuntimeError)
  No_Prev = Class.new(RuntimeError)

  class << self

    def Back arr
      size = arr.size
      arr.reverse.each_with_index { |v, i|

        real_index = (size - 1) - i

        meta = Meta.new(:back)
        meta.value = v
        meta.real_index = real_index
        meta.last_index = size - 1
        meta.i     = i
        meta.next  = nil
        meta.prev  = nil
        meta.fin

        yield meta.value, meta.real_index, meta
      }
    end

    def Forward arr
      size = arr.size
      arr.each_with_index { |v, i|
        real_index = i

        meta = Meta.new(:forward)
        meta.value = v
        meta.real_index = real_index
        meta.last_index = size - 1
        meta.i     = i
        meta.next  = nil
        meta.prev  = nil
        meta.fin

        yield meta.value, meta.real_index, meta
      }
    end

  end # === class self ===

  class Meta

    def initialize dir
      @is_fin = false
      @data   = {}
      @dir    = dir
      @real_index = nil
      @last_index = nil
      @value  = nil
      @i      = nil

      @next   = nil
      @prev   = nil
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
    end

    def prev
      @msg ||= if forward?
                 "This is the first position."
               else
                 "This is the last position."
               end
      raise No_Prev, @msg if !prev?
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
