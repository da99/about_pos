
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

    end # === describe prev ===

    describe "next" do

      it "has value of next item" do
        track = []
        About_Pos.Back([1,2,3,4]) do |v,i,m|
          track.push(m.next? ? m.next.value : nil)
        end
        track.should == [3, 2, 1, nil]
      end

    end # === describe next ===

  end # === describe Meta ===

end # === describe about_pos ===
