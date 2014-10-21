# -*- coding: utf-8 -*-
s = I18n.t('speakers').map(&:first).inject({}) { |res, name| res[name] = I18n.transliterate(name.split.join); res  }

path_to_image = ->(name) { "speakers/#{name.split.join}.jpg" }
path_to_tpl = ->(tname) {"app/views/speakers/#{tname}.html.erb"}
gen_tpl = ->(name, path_to_image) {
<<END
<p>Описание скоро появится!</p>
END
}

require 'pathname'
s.each do |(name, tname)|
  unless (f = Pathname.new(path_to_tpl.call(tname))).exist?
    f.write(gen_tpl.call(name, path_to_image.call(name)))
  end
end

