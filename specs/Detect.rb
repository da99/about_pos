
describe :detect do

  describe :Back do

    it "returns first value that is truthy" do
      tracks = []
      result = About_Pos.Back([1,2,3,4]).detect do |v,i,m|
        tracks << v
        v == 2
      end
      tracks.should == [4,3,2]
    end # === it returns first value that is truthy

  end # === describe :Back

  describe :Forward do

    it "returns first value that is truthy" do
      tracks = []
      result = About_Pos.Forward([1,2,3,4,5]).detect do |v,i,m|
        tracks << v
        v == 3
      end
      tracks.should == [1,2,3]
    end # === it returns first value that is truthy

  end # === describe :Forward

end # === describe :Detect
