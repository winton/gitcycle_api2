module Updaters
  module Title

    def update_from_title?
      title_changed?
    end

    def update_from_title
      return  if self.name

      name        = title.downcase
      valid_chars = /[^a-zA-Z]/
      many_dashes = /-{2,}/
      wrong_dash  = /^-|-$/

      name.gsub!(valid_chars, '-')
      name.gsub!(many_dashes, '-')
      name.gsub!(wrong_dash,  '')

      if name.length > 30
        last_word = /-[^-]*$/
        name      = name[0..29].gsub(last_word, '')
      end

      self.name = name
    end
  end
end