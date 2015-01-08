
class About_Pos

  No_Next = Class.new(RuntimeError)
  No_Prev = Class.new(RuntimeError)

  class << self

    def Back arr, &blok
      Move(:back, arr, &blok)
    end

    def Forward arr, &blok
      Move(:forward, arr, &blok)
    end

    private
    def Move dir, arr
      size = arr.size

      if dir == :forward
        real_index = 0
        seq = arr
      else
        real_index = (size - 1) - 0
        seq = arr.reverse
      end

      meta = Meta.new(dir, real_index, arr)

      seq.each_with_index { |v, i|
        yield meta.value, meta.real_index, meta
        if meta.next?
          meta = meta.next
        else
          break
        end
      }
    end

  end # === class self ===

  class Meta

    def initialize dir, real_index, arr, prev = nil
      @arr        = arr
      @data       = {}
      @dir        = dir
      @last_index = arr.size - 1

      @real_index = real_index

      @next = nil
      @prev = prev
    end

    def value
      arr[real_index]
    end

    [
      :arr,
      :real_index,
      :last_index
    ].each { |v|
      eval %~
        def #{v}
          raise "Value not set for: #{v}" if @#{v}.nil?
          @#{v}
        end
      ~
    }

    def grab
      raise No_Next, "No more values to grab" unless next?
      if forward?
        @real_index += 1
      else
        @real_index -= 1
      end
      value
    end

    def next
      @msg ||= if forward?
                 "This is the last position."
               else
                 "This is the first position."
               end
      raise No_Next, @msg if !next?

      @next ||= begin
                  if forward?
                    Meta.new(dir, real_index + 1, arr, self)
                  else
                    Meta.new(dir, real_index - 1, arr, self)
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
                    Meta.new(dir, real_index - 1, arr)
                  else
                    Meta.new(dir, real_index + 1, arr)
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
        real_index < last_index
      else
        real_index > 0
      end
    end

    def prev?
      if forward?
        real_index > 0
      else
        real_index < last_index
      end
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
