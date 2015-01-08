
describe "Forward" do

  it "runs items in forward fashion" do
    track = []
    About_Pos.Forward([1,2,3]) do |v, i, m|
      track.push v
    end
    track.should == [1,2,3]
  end

  it "provides the real index" do
    track = []
    About_Pos.Forward([1,2,3,4]) do | v, i, m |
      track.push i
    end
    track.should == [0,1,2,3]
  end

  describe "Meta" do

    describe "prev?" do
      it "is false when index == 0" do
        track = []
        About_Pos.Forward([1,2,3,4]) do | v, i, m |
          track.push m.prev?
        end
        track.should == [false, true, true, true]
      end
    end # === describe prev? ===

    describe "next?" do
      it "is false when index == last index" do
        track = []
        About_Pos.Forward([1,2,3,4]) do | v, i, m |
          track.push m.next?
        end
        track.should == [true, true, true, false]
      end
    end # === describe next? ===

    describe "next" do

      it "contains .value for next" do
        track = []
        About_Pos.Forward([1,2,3,4]) do | v, i, m |
          track.push(m.next.value) if m.next?
        end
        track.should == [2,3,4]
      end

      it "raises an error if there is no next value" do
        lambda {
          About_Pos.Forward([1,2,3,4]) do | v, i, m |
            m.next
          end
        }.should.raise(About_Pos::No_Next)
        .message.should.match /This is the last position/i
      end

    end # === describe next ===

    describe "prev" do

      it "contains a .value for prev" do
        track = []
        About_Pos.Forward([1,2,3,4]) do | v, i, m |
          track.push(m.prev.value) if m.prev?
        end
        track.should == [1,2,3]
      end

      it "raises an error if there is no prev value" do
        lambda {
          About_Pos.Forward([1,2,3,4]) do | v, i, m |
            m.prev
          end
        }.should.raise(About_Pos::No_Prev)
        .message.should.match /This is the first position/i
      end

    end # === describe prev ===

    describe :grab do

      it "takes the next value" do
        tracks = []
        About_Pos.Forward([1,2,3,4]) do |v,i,m|
          tracks << m.grab
        end
        tracks.should == [2,4]
      end # === it takes the next value

      it "skips the value that was taken" do
        tracks = []
        About_Pos.Forward([1,2,3,4]) do |v,i,m|
          tracks << v
          m.grab
        end
        tracks.should == [1,3]
      end # === it skips the value that was taken

      it "raises an error if there aren't anymore values" do
        lambda {
          About_Pos.Forward([1,2,3,4]) do |v,i,m|
            5.times { m.grab }
          end
        }.should.raise(About_Pos::No_Next).
        message.should.match /No more values to grab/
      end # === it raises an error if there aren't anymore values

    end # === describe :grab

    describe "saving/reading data ([], []=)" do

      it "saves a value to be used on .prev meta" do
        vals   = [:a, :b, :c]
        track  = []
        About_Pos.Forward([1,2,3,4]) do | v, i, m |
          m[:test_val] = vals.shift

          if m.prev?
            track.push( m.prev[:test_val] )
          else
            track.push nil
          end
        end
        track.should == [nil,:a,:b,:c]
      end

      it "saves a value to be used on .next meta" do
        vals = [:d, :e, :f]
        track = []
        About_Pos.Forward([1,2,3,4]) do |v,i,m|
          if m.next?
            m.next[:test_val] = vals.shift
          end
          track.push m[:test_val]
        end
        track.should == [nil, :d, :e, :f]
      end

    end # === describe []/[]= ===

  end # === describe Meta ===

end # === describe about_pos ===





