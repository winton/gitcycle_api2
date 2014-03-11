class BuildBranch
  class Options < Struct.new(:params)

    def options
      branch, title, url = parse_query

      if branch
        options = { branch: branch }
      elsif url
        options = ticket_provider_option(url)
      elsif title
        options = { title: title }
      else
        options = {}
      end

      params.symbolize_keys.merge(options)
    end

    def parse_query
      query = params[:query]
      
      if query =~ /^https?:\/\//
        [ nil, nil, query ]
      elsif query =~ /\s/
        [ nil, query, nil ]
      else
        [ query, nil, nil ]
      end
    end

    def ticket_provider_option(url)
      if url.include?('lighthouseapp.com/')
        { :lighthouse_url => url }
      elsif url.include?('github.com/')
        { :github_url => url }
      end
    end
  end
end