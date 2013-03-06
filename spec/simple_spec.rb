require "jekyll"
require "jekyll/site"

describe "simple test", "#score" do
  it "should require Jekyll" do
    Jekyll::Site.new(Jekyll::DEFAULTS).should eq(0)
  end
end
