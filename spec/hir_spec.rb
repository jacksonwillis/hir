$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "hir"

describe :hir do
  it "writes html" do
    hir { div }.should eq "<div></div>"
    hir { p "Lorem ipsum" }.should eq "<p>Lorem ipsum</p>"
  end

  it "allows tag attributes" do
    hir { p "LOL!", :class => "userPost" }.should eq "<p class='userPost'>LOL!</p>"
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
    hir { meta! :charset => "UTF-8" }.should eq "<meta charset='UTF-8'/>"
  end

  it "handles special cases" do
    hir { comment "invisible" }.should eq "<!-- invisible -->"
    hir { doctype! }.should eq "<!DOCTYPE html>\n"
    hir {
      p do
        strong "something"
        none " another thing "
        em "the next thing"
      end
    }.should eq "<p><strong>something</something> another thing <em>the next thing</em></p>"
  end

  it "allows user-defined tags" do
    HIR::Tags.add_tag :foo
    hir { foo "bar" }.should eq "<foo>bar</foo>"
  end

  it "allows tag templates" do
    def error_box(content = "", &block)
      hir { div(content, :class => "error", &block) }
    end

    error_box.should eq "<div class='error'></div>"
    error_box("An error has occured.").should eq "<div class='error'>An error has occured.</div>"
    error_box { p "test" }.should eq "<div class='error'><p>test</p></div>"
  end
end
