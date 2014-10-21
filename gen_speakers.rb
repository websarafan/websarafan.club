# -*- coding: utf-8 -*-
s = I18n.t('speakers').map(&:first).inject({}) { |res, name| res[name] = I18n.transliterate(name.split.join); res  }
s.delete('Евгений Тупикин')
s.delete('Алена Муравлянская')

path_to_image = ->(name) { "speakers/#{name.split.join}.jpg" }
path_to_tpl = ->(tname) {"app/views/speakers/#{tname}.html.erb"}
gen_tpl = ->(name, path_to_image) {
<<END
<div class="row speaker-details">
  <div class="large-12 columns">
    <h1 class="text-center">#{name}</h1>
    <img src="<%= image_path('#{path_to_image}') %>" />
    <div class="text-center">
      <a href="<%=payment_path%>" class="button" role="button">Присоединяйтесь!</a>
    </div>
  </div>
</div>
END
}

require 'pathname'
s.each do |(name, tname)|
  if (f = Pathname.new(path_to_tpl.call(tname))).exist?
    f.write(gen_tpl.call(name, path_to_image.call(name)))
  end
end

