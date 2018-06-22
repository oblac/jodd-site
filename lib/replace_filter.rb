class MarkdownCodeFenceColorize < Nanoc::Filter
  identifier :jodd_replace

  def run(content, params={})

	# just in case
	content = content.gsub("{{TOC}}", '')

	# fix error color in syntax highlighter
	content = content.gsub(
		%[<span class="error">$</span>],
		%[<span style="color:#F00;background-color:#FEE">$</span>])

	# releases
	content = content.gsub(
		%[<dt>NEW</dt>],
		%[<dt class="tag-new">NEW</dt>])

	content = content.gsub(
		%[<dt>CHANGED</dt>],
		%[<dt class="tag-changed">CHANGED</dt>])

	content = content.gsub(
		%[<dt>FIXED</dt>],
		%[<dt class="tag-fixed">FIXED</dt>])


	# add class names for Jodd names
	content = content.gsub(
		%[<em>Jodd</em>],
		%[<em class="jodd">Jodd</em>])

	content = content.gsub(
		%[<em>Madvoc</em>],
		%[<em class="jodd">Madvoc</em>])

	content = content.gsub(
		%[<em>Petite</em>],
		%[<em class="jodd">Petite</em>])

	content = content.gsub(
		%[<em>Jerry</em>],
		%[<em class="jodd">Jerry</em>])

	content = content.gsub(
		%[<em>CSSelly</em>],
		%[<em class="jodd">CSSelly</em>])

	content = content.gsub(
		%[<em>Db</em>],
		%[<em class="jodd">Db</em>])

	content = content.gsub(
		%[<em>DbOom</em>],
		%[<em class="jodd">DbOom</em>])

	content = content.gsub(
		%[<em>Decora</em>],
		%[<em class="jodd">Decora</em>])

	content = content.gsub(
		%[<em>Lagarto</em>],
		%[<em class="jodd">Lagarto</em>])

	content = content.gsub(
		%[<em>HTTP</em>],
		%[<em class="jodd">HTTP</em>])

	content = content.gsub(
		%[<em>BeanUtil</em>],
		%[<em class="jodd">BeanUtil</em>])

	content = content.gsub(
		%[<em>Joy</em>],
		%[<em class="jodd">Joy</em>])

	content = content.gsub(
		%[<em>Props</em>],
		%[<em class="jodd">Props</em>])

	content = content.gsub(
		%[<em>HtmlStapler</em>],
		%[<em class="jodd">HtmlStapler</em>])

	content = content.gsub(
		%[<em>VTor</em>],
		%[<em class="jodd">VTor</em>])

	content = content.gsub(
		%[<em>JTX</em>],
		%[<em class="jodd">JTX</em>])

	content = content.gsub(
		%[<em>Proxetta</em>],
		%[<em class="jodd">Proxetta</em>])

	content = content.gsub(
		%[<em>Paramo</em>],
		%[<em class="jodd">Paramo</em>])

	content = content.gsub(
		%[<em>Lagarto DOM</em>],
		%[<em class="jodd">Lagarto DOM</em>])

	content = content.gsub(
		%[<em>Methref</em>],
		%[<em class="jodd">Methref</em>])

	content = content.gsub(
		%[<em>Joy</em>],
		%[<em class="jodd">Joy</em>])

	content = content.gsub(
		%[<em>StripHtml</em>],
		%[<em class="jodd">StripHtml</em>])

	content = content.gsub(
		%[<em>Uphea</em>],
		%[<em class="jodd">Uphea</em>])

	content = content.gsub(
		%[<em>Json</em>],
		%[<em class="jodd">Json</em>])

	content = content.gsub(
		%[<em>CLI</em>],
		%[<em class="jodd">CLI</em>])

	content
  end
end
