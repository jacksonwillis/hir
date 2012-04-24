class Hash
  def to_html_attrs
    map { |k, v| " #{k}='#{v}'" }.join
  end
end

class HIR
  module HTMLTags

    def self.declare_tag(tagname)
      define_method(tagname, ->(*args, &block) { tag(tagname, *args, &block) })
      define_method("#{tagname}!", ->(*args, &block) { tag_sc(tagname, *args) })
    end

    def self.declare_tags(*tagnames)
      tagnames.each { |tagname| declare_tag(tagname) }
    end

    declare_tags *%w[
       a abbr acronym address applet area article aside audio b base basefont
       bdi bdo big blockquote body br button canvas caption center cite code
       col colgroup command datalist dd del details dfn dir div dl dt em embed
       fieldset figcaption figure font footer form frame frameset h1 head
       header hgroup hr html i iframe img input ins keygen kbd label legend li
       link map mark menu meta meter nav noframes noscript object ol optgroup
       option output p param pre progress q rp rt ruby s samp script section
       select small source span strike strong style sub summary sup table tbody
       td textarea tfoot th thead time title tr track tt u ul var video wbr ]

    def doctype!
      handle_output "<!DOCTYPE html>\n"
    end

    def comment(content)
      handle_output "<!-- #{content} -->"
    end

    private

      def tag(tagname, content = "", options = {}, &script)
        handle_output "<#{tagname}#{options.to_html_attrs}>#{content}#{HIR.evaluate(&script) if block_given?}</#{tagname}>"
      end

      # self-closing tag
      def tag_sc(tagname, options = {})
        handle_output "<#{tagname}#{options.to_html_attrs}/>"
      end

      def handle_output(output)
        self.class.eql?(HIR) ? (@tags << output).join : output
      end

  end

  class << self
    def evaluate(&script)
      self.new.instance_eval(&script).to_s
    end
  end

  include HTMLTags

  def initialize
    @tags = []
  end

  def to_s
    @tags.join
  end
end

def hir(&script)
  HIR.evaluate(&script)
end
