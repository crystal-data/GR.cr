require "./spec_helper"

describe GR do
  # TODO: Write tests

  describe "#version" do
    it "returns the version" do
      GR.version.should match(/^\d+\.\d+\.\d+$/)
    end
  end
end
