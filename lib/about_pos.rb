
class About_Pos

  No_Next = Class.new(RuntimeError)
  No_Prev = Class.new(RuntimeError)

  class Enum

    include Enumerable

    def initialize dir, arr
      @arr = arr
      if dir == :forward
        @real_index = 0
      else
        @real_index = (@arr.size - 1) - 0
      end

      @meta = Meta.new(dir, @real_index, arr)
    end

    def each
      return nil if @arr.empty?
      has_next = false
      begin
        result = yield @meta.value, @meta.real_index, @meta
        has_next = @meta.next?
        if has_next
          @meta.next!
        end
      end while has_next
    end

  end # === class Enum

  class << self

    def Back arr
      if block_given?
        Back(arr).each { |v,i,m| yield v, i, m }
      else
        Enum.new(:back, arr)
      end
    end

    def Forward arr
      if block_given?
        Forward(arr).each { |v,i,m| yield v, i, m }
      else
        Enum.new(:forward, arr)
      end
    end

  end # === class self ===

  class Meta

    def initialize dir, real_index, arr, prev = nil
      @arr        = arr
      @data       = {}
      @dir        = dir
      @last_index = arr.size - 1
      @real_index = real_index
      @prev       = prev
    end

    def data
      @data
    end

    def data= d
      @data = d
    end

    def [] k
      @data[@real_index] ||= {}
      @data[@real_index][k]
    end

    def []= k, v
      self[k]
      @data[@real_index][k] = v
    end

    def dup
      d = super
      d.data= @data
      d
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
      m = dup
      m.next!
      m
    end

    def prev
      m = dup
      m.prev!
      m
    end

    def next!
      @msg ||= if forward?
                 "This is the last position."
               else
                 "This is the first position."
               end
      raise No_Next, @msg if !next?

      if forward?
        @real_index = @real_index + 1
      else
        @real_index = @real_index - 1
      end

      value
    end

    def prev!
      @msg ||= if forward?
                 "This is the first position."
               else
                 "This is the last position."
               end
      raise No_Prev, @msg if !prev?

      if forward?
        @real_index = real_index - 1
      else
        @real_index = real_index + 1
      end

      value
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

  end # === class Meta ===


end # === class About_Pos ===
