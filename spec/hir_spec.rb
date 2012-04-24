$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "hir"

describe :hir do
  it "writes html" do
    hir { div }.should eq "<div></div>"
    hir { p "Lorem ipsum" }.should eq "<p>Lorem ipsum</p>"
  end

  it "allows tag attributes" do
    hir { p "LOL!", class: "userPost" }.should eq "<p class='userPost'>LOL!</p>"
  end

  it "allows nesting" do
    hir {
      h1 "Pets"
      ul do
        li "dags"
        li "cats"
        li "other"
      end
    }.should eq "<h1>Pets</h1><ul><li>dags</li><li>cats</li><li>other</li></ul>"
  end

  it "allows self-closing tags" do
    hir { br! }.should eq "<br/>"
    hir { meta! charset: "UTF-8" }.should eq "<meta charset='UTF-8'/>"
  end

  it "handles special cases" do
    hir { comment "invisible" }.should eq "<!-- invisible -->"
    hir { doctype! }.should eq "<!DOCTYPE html>\n"
  end
end
