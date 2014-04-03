
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

end # === describe about_pos ===
