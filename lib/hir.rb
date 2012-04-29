class Hash
  def to_html_attrs
    map { |k, v| " #{k}='#{v}'" }.join
  end
end

class HIR
  VERSION = "1.1.0"

  module Tags

    def self.add_tag(tagname)
      define_method(tagname)  { |*args, &block| tag(tagname, *args, &block) }
      define_method("#{tagname}!") { |*args, &block| tag_sc(tagname, *args) }
    end

    def self.add_tags(*tagnames)
      tagnames.each { |tagname| add_tag(tagname) }
    end

    add_tags *%w[
       a abbr acronym address applet area article aside audio b base basefont
       bdi bdo big blockquote body br button canvas caption center cite code
       col colgroup command datalist dd del details dfn dir div dl dt em embed
       fieldset figcaption figure font footer form frame frameset h1 h2 h3 h4
       h5 h6 head header hgroup hr html i iframe img input ins keygen kbd label
       legend li link map mark menu meta meter nav noframes noscript object ol
       optgroup option output p param pre progress q rp rt ruby s samp script
       section select small source span strike strong style sub summary sup
       table tbody td textarea tfoot th thead time title tr track tt u ul var
       video wbr ]

    def doctype!
      handle_output "<!DOCTYPE html>\n"
    end

    def comment(content)
      handle_output "<!-- #{content} -->"
    end

    def none(content)
      handle_output content
    end

    def sir(styles)
      handle_output styles.map { |target, rules|
        "#{target}{#{rules.map { |rule| "#{rule[0]}:#{rule[1]}" }.join(";")}}" }.join
    end

    private

      def tag(tagname, content = "", options = {}, &children)
        handle_output "<#{tagname}#{options.to_html_attrs}>#{content}" \
                      "#{HIR.to_html(&children) if block_given?}</#{tagname}>"
      end

      # self-closing tag
      def tag_sc(tagname, options = {})
        handle_output "<#{tagname}#{options.to_html_attrs}/>"
      end

      def handle_output(output)
        self.class.eql?(HIR) ? @tags << output : output
      end

  end

  def self.to_html(&content)
    html_page = HIR.new
    html_page.instance_eval(&content)
    html_page.to_s
  end

  include Tags

  def initialize
    @tags = []
  end

  def to_s
    @tags.join
  end
end

def hir(&content)
  HIR.to_html(&content)
end
