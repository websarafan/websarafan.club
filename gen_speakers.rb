# -*- coding: utf-8 -*-
s = I18n.t('speakers').map(&:first).inject({}) { |res, name| res[name] = I18n.transliterate(name.split.join); res  }
# s.delete('Евгений Тупикин')

path_to_image = ->(name) { "speakers/#{name.split.join}.jpg" }
path_to_tpl = ->(tname) {"app/views/speakers/#{tname}.html.erb"}
gen_tpl = ->(name, path_to_image) {
<<END
<div class="row">
  <div class="large-12 columns">
    <div class="large-8 columns">
    <h1 class="text-center">#{name}</h1>

    <div class="text-center">
      <a href="<%=payment_path%>" class="button" role="button">Присоединяйтесь!</a>
    </div>

    </div>
    <div class="large-4 columns text-center author-column">
      <p><img src="<%= image_path('#{path_to_image}') %>" /></p>
    </div>    
  </div>
</div>
END
}

require 'pathname'
s.each do |(name, tname)|
  unless (f = Pathname.new(path_to_tpl.call(tname))).exist?
    f.write(gen_tpl.call(name, path_to_image.call(name)))
  end
end

