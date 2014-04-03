
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

  describe "Meta#next" do

    it "contains a .value for next" do
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

  end # === describe Meta ===

  describe "Meta#prev" do

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

  end # === describe Meta#prev ===

end # === describe about_pos ===
