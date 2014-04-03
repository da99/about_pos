
class About_Pos

  No_Next = Class.new(RuntimeError)
  No_Prev = Class.new(RuntimeError)

  class << self

    def Back arr
      size = arr.size
      arr_r = arr.reverse

      arr.reverse.each_with_index { |v, i|
        real_index = (size - 1) - i
        meta = Meta.new(:back, real_index, i, arr)
        yield meta.value, meta.real_index, meta
      }
    end

    def Forward arr
      size = arr.size
      arr.each_with_index { |v, i|
        meta = Meta.new(:forward, i, i, arr)
        yield meta.value, meta.real_index, meta
      }
    end

  end # === class self ===

  class Meta

    def initialize dir, real_index, i, arr
      @arr        = arr
      @data       = {}
      @dir        = dir
      @last_index = arr.size - 1

      @real_index = real_index
      @value      = arr[real_index]
      @i          = i

      @next = nil
      @prev = nil

    end

    [
      :arr,
      :real_index,
      :last_index,
      :value, :i
    ].each { |v|
      eval %~
        def #{v}
          raise "Value not set for: #{v}" if @#{v}.nil?
          @#{v}
        end
      ~
    }

    def next
      @msg ||= if forward?
                 "This is the last position."
               else
                 "This is the first position."
               end
      raise No_Next, @msg if !next?

      @next ||= begin
                  if forward?
                    Meta.new(dir, real_index + 1, self.i + 1, arr)
                  else
                    Meta.new(dir, real_index - 1, self.i - 1, arr)
                  end
                end
    end

    def prev
      @msg ||= if forward?
                 "This is the first position."
               else
                 "This is the last position."
               end
      raise No_Prev, @msg if !prev?

      @prev ||= begin
                  if forward?
                    Meta.new(dir, real_index - 1, self.i - 1, arr)
                  else
                    Meta.new(dir, real_index + 1, self.i + 1, arr)
                  end
                end
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
