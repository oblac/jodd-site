# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

module JoddMacros
  require 'nanoc/helpers/html_escape'
    include Nanoc::Helpers::HTMLEscape

  # outputs javadoc link
  def javadoc(item)
    javadoc_key = item[:javadoc]

    value = ''
    if (javadoc_key != nil)
      value = %[<a href="http://oblac.github.io/jodd-site/javadoc/?jodd/#{javadoc_key}/package-summary.html" target="_new" class="javadoc"><img src="/gfx/javadoc.png" alt="javadoc"/></a>]
    end

    value
  end

  def github_edit(item)

    value = item.identifier
    value = "https://github.com/oblac/jodd-site/edit/master/content" + value

    value
  end

end

include JoddMacros