
describe "Back" do

  it "runs items in reverse" do
    track = []
    About_Pos.Back([1,2,3]) do |v, i, m|
      track.push v
    end
    track.should == [3,2,1]
  end

  it "provides the real index" do
    track = []
    About_Pos.Back([1,2,3]) do |v, i, m|
      track.push i
    end
    track.should == [2, 1, 0]
  end

  describe "Meta" do

    describe "prev?" do

      it "is false when at first item (real last item)" do
        track = []
        About_Pos.Back([1,2,3]) do |v, i, m|
          track.push m.prev?
        end
        track.should == [false, true, true]
      end

    end # === describe prev? ===

    describe "next?" do

      it "is first if it reaches the last item (real first item)" do
        track = []
        About_Pos.Back([4,5,6]) do |v,i,m|
          track.push m.next?
        end
        track.should == [true, true, false]
      end

    end # === describe next? ===

    describe "prev" do

      it "has value of previous item" do
        track = []
        About_Pos.Back([8,9,1,2]) do |v,i,m|
          track.push(m.prev? ? m.prev.value : nil)
        end
        track.should == [nil, 2, 1, 9]
      end

      it "holds data from previous iterations" do
        track = []
        vals = [:a, :b, :c, :d]
        About_Pos.Back([8,9,1,2]) do |v,i,m|
          if m.prev?
            track.push m.prev[:test_val]
          else
            track.push nil
          end
          m[:test_val] = vals.shift
        end
        track.should == [nil, :a, :b, :c]
      end

    end # === describe prev ===

    describe "next" do

      it "has value of next item" do
        track = []
        About_Pos.Back([1,2,3,4]) do |v,i,m|
          track.push(m.next? ? m.next.value : nil)
        end
        track.should == [3, 2, 1, nil]
      end

      it "saves data that is accesible in the next iteration" do
        track = []
        vals = [:a, :b, :c]
        About_Pos.Back([1,2,3]) { | v, i, m |
          (m.next[:test_val] = vals.shift) if m.next?
          track.push(m[:test_val])
        }
        track.should == [nil, :a, :b]
      end

    end # === describe next ===

    describe :grab do

      it "grabs the :next value" do
        tracks = []
        About_Pos.Back([1,2,3,4]) { |v,i,m|
          tracks << m.grab
        }
        tracks.should == [3,1]
      end # === it grabs the :next value

      it "skips grabbed values" do
        tracks = []
        About_Pos.Back([1,2,3,4,5]) { |v,i,m|
          tracks << m.grab if m.next?
        }
        tracks.should == [4,2]
      end # === it skips grabbed values

    end # === describe :grab

    describe ".top?" do

      it "returns true if at real first" do
        track = []
        About_Pos.Back([1,2,3,4,5]) { |v,i,m| track.push m.top?  }
        track.should == [false, false, false, false, true]
      end

    end # === describe .top? ===

    describe ".middle?" do

      it "returns true if not at real first and real last" do
        track = []
        About_Pos.Back([4,5,6]) { |v,i,m| track.push m.middle?  }
        track.should == [false, true, false]
      end

    end # === describe .middle? ===

    describe ".bottom?" do

      it "returns true if at real last" do
        track = []
        About_Pos.Back([10,11,12,15]) { |v,i,m| track.push m.bottom?  }
        track.should == [true, false, false, false]
      end

    end # === describe .bottom? ===

  end # === describe Meta ===

end # === describe about_pos ===
