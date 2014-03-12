require 'spec_helper'

describe BuildBranch::Options do

  let(:params)  { {} }
  let(:options) { BuildBranch::Options.new(params) }
  subject       { options }

  describe "#options" do

    let(:query) { "query" }

    before  { options.params[:query] = query }
    subject { options.options }

    context "when query contains url" do
      let(:ticket_provider_option) { { worked: true } }

      before do
        allow(options).to receive(:query_is_url?).and_return(true)
        allow(options).to receive(:ticket_provider_option).and_return(ticket_provider_option)
      end

      it { should == options.params.merge(ticket_provider_option) }
    end

    context "when query has a space" do

      before do
        allow(options).to receive(:query_has_space?).and_return(true)
      end

      it { should == options.params.merge(title: query) }
    end

    context "when query is a branch" do

      it { should == options.params.merge(branch: query) }
    end
  end

  describe "#ticket_provider_option" do

    before  { options.query = query }
    subject { options.ticket_provider_option }

    context "when query contains lighthouse url" do

      let(:query) { "http://lighthouseapp.com/" }

      it { should == { lighthouse_url: query } }
    end

    context "when query contains github url" do

      let(:query) { "http://github.com/" }

      it { should == { github_url: query } }
    end
  end

  describe "#query_has_space?" do

    subject { options.query_has_space? }

    context "when query has space" do

      before { options.query = "has space" }

      it { should == true }
    end

    context "when query does not have space" do

      before { options.query = "nospace" }

      it { should == false }
    end
  end

  describe "#query_is_url?" do

    subject { options.query_is_url? }

    context "when query is a url" do

      before { options.query = "http://" }

      it { should == true }
    end

    context "when query is not a url" do
      
      before { options.query = "noturl" }

      it { should == false }
    end
  end
end