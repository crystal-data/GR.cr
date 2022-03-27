require "./spec_helper"

describe GR do
  # TODO: Write tests

  describe "#version" do
    it "returns the version" do
      v = GR.version
      if v == "Unknown"
        v.should eq "Unknown"
      else
        v.should match(/^\d+\.\d+\.\d+$/)
      end
    end
  end
end
