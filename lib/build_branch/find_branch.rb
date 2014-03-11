class BuildBranch
  class FindBranch < Struct.new(:options)

    attr_accessor :lh_url, :gh_url

    def branch_conditions
      where = {}

      id      = options[:id]
      name    = options[:branch]
      title   = options[:title]
      @lh_url = options[:lighthouse_url]
      @gh_url = options[:github_url]
      
      if id
        where[:id] = id

      elsif name
        where[:name] = name

      elsif title
        where[:title] = title
      
      elsif lh_url
        where.merge! lighthouse_conditions
      
      elsif gh_url
        where.merge! github_conditions
      end

      where
    end

    def find
      Branch.where(branch_conditions).first_or_initialize
    end

    def github_conditions
      GithubUrl.new(gh_url).to_conditions
    end

    def lighthouse_conditions
      LighthouseUrl.new(lh_url).to_conditions
    end
  end
end