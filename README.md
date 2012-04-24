# hir: HTML in Ruby

[![Build Status](https://secure.travis-ci.org/jacksonwillis/hir.png?branch=master)](http://travis-ci.org/jacksonwillis/hir)

    $ gem install hir

## Examples

### Ruby as HTML!

```ruby
require "hir"

hir { strong "Hello, world!" } #=> "<strong>Hello, world!</strong>
```

### Nesting elements

```ruby
hir do
  h1 "grocery list"

  ul do
    li "apple"
    li "cheese"
    li "milk"
  end
end #=> "<h1>grocery list</h1><ul><li>apple</li><li>cheese</li><li>milk</li></ul>"
```

### Attributes and self-closing tags

```ruby
hir { meta! charset: "UTF-8" } #=> "<meta charset='UTF-8'/>"
hir { p "Lorem ipsum", class: "foo" } #=> "<p class='foo'>Lorem ipsum</p>"
```

### Use outside of the `hir` block by including the module

```ruby
include HIR::HTMLTags
header { h1 "lol" } #=> "<header><h1>lol</h1></header>"
```

## Extension

### Declare your own tags!

```ruby
HIR::HTMLTags.declare_tag :myTag
hir { myTag "test" } #=> "<myTag>test</myTag>"
```

### Custom tags

```ruby
def error_box(content = "", &block)
  hir { div(content, class: "error", &block) }
end

error_box #=> "<div class='error'></div>"
error_box "An error has occured" #=> "<div class='error'>An error has occured</div>"
error_box do
  p "The following errors have occured:"
  ul do
    li "FuntimeError"
    li "StackUnderflowError"
  end
end #=> "<div class='error'><p>The following errors have occured:</p><ul><li>FuntimeError</li><li>StackUnderflowError</li></ul></div>"
```

## Template layout

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
