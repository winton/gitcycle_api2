class BuildBranch
  class FindBranch < Struct.new(:options)

    def branch_conditions
      where = {}

      id     = options[:id]
      name   = options[:branch]
      title  = options[:title]
      lh_url = options[:lighthouse_url]
      gh_url = options[:github_url]
      
      if id
        where[:id] = id

      elsif name
        where[:name] = name

      elsif title
        where[:title] = title
      
      elsif lh_url
        where.merge! LighthouseUrl.new(lh_url).to_conditions
      
      elsif gh_url
        where.merge! GithubUrl.new(gh_url).to_conditions
      end

      where
    end

    def find
      Branch.where(branch_conditions).first_or_initialize
    end
  end
end