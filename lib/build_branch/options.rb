class BuildBranch
  class Options < Struct.new(:params)

    attr_accessor :query

    def options
      @query = params[:query]

      if query_is_url?
        options = ticket_provider_option
      elsif query_has_space?
        options = { title: query }
      elsif query
        options = { branch: query }
      else
        options = {}
      end

      params.symbolize_keys.merge(options)
    end

    def ticket_provider_option
      if query.include?('lighthouseapp.com/')
        { lighthouse_url: query }
      elsif query.include?('github.com/')
        { github_url: query }
      end
    end

    def query_has_space?
      !!(query =~ /\s/)
    end

    def query_is_url?
      !!(query =~ /^https?:\/\//)
    end
  end
end