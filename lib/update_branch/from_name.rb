class UpdateBranch
  class FromName < Struct.new(:branch)

    def update?
      !branch.name && branch.title_changed?
    end

    def update
      return  unless update?

      name        = branch.title.downcase
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

      branch.name = name
    end
  end
end