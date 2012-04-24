# hir: HTML in Ruby

## Examples

### Ruby as HTML!

```ruby
require "hir"

hir { strong "Hello, world!" } #=> "<strong>Hello, world!</strong>

hir do
  h1 "grocery list"

  ul do
    li "apple"
    li "cheese"
    li "milk"
  end
end #=> "<h1>grocery list</h1><ul><li>apple</li><li>cheese</li><li>milk</li></ul>"

# Attributes and self-closing tags
hir { meta! charset: "UTF-8" } #=> "<meta charset='UTF-8'/>"
hir { p "Lorem ipsum", class: "foo" } #=> "<p class='foo'>Lorem ipsum</p>"

# use outside of the `hir` block by including the module
include HIR::HTMLTags
header { h1 "lol" } #=> "<header><h1>lol</h1></header>"

# declare your own tags!
HIR::HTMLTags.declare_tag :myTag
myTag "test" #=> "<myTag>test</myTag>"
```

### Template layout

```ruby
require "hir"

def default_layout(&content)
  hir do
    doctype!
    html do
      head do
        title "hir test"
        meta! charset: "UTF-8"
      end
      body do
        header do
          h1 "hir test"
        end
        section(nil, id: "content", &content)
      end
    end
  end
end

default_layout { p "Lorem ipsum, dolor sit amet" }
#=> "<!DOCTYPE html>\n<html><head><title>hir test</title>" \
#   "<meta charset='UTF-8'/></head><body><header><h1>hir test</h1></header>" \
#   "<section id='content'><p>Lorem ipsum, dolor sit amet</p></section></body></html>"
```
