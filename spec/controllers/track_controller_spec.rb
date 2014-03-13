require 'spec_helper'

describe TrackController do

  let(:user) do
    FactoryGirl.create(:user)
  end

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(user.gitcycle)
  end

  describe "PUT #track" do

    let(:query)  { "query" }
    let(:repo)   { "repo" }
    let(:source) { "source" }

    before do
      Repo.any_instance.stub(:owner).and_return(user)
      Github.any_instance.stub(:reference).and_return(ref: true)
    end

    subject do
      put(:update, { repo: repo, query: query, source: source }.merge(format: :json))
      JSON.parse(response.body, symbolize_names: true)
    end

    # it { pp subject }

    specify { expect(subject[:branch]).to be_a(Hash) }
    specify { expect(subject[:branch][:id]).to be_a(Fixnum) }
    specify { expect(subject[:branch][:name]).to eq(query) }
    specify { expect(subject[:branch][:repo]).to be_a(Hash) }
    specify { expect(subject[:branch][:repo][:id]).to be_a(Fixnum) }
    specify { expect(subject[:branch][:repo][:name]).to eq(repo) }
    specify { expect(subject[:branch][:repo][:user]).to be_a(Hash) }
    specify { expect(subject[:branch][:repo][:user][:id]).to be_a(Fixnum) }
    specify { expect(subject[:branch][:source_branch]).to be_a(Hash) }
    specify { expect(subject[:branch][:source_branch][:id]).to be_a(Fixnum) }
    specify { expect(subject[:branch][:source_branch][:name]).to eq(source) }
    specify { expect(subject[:branch][:source_branch][:repo]).to be_a(Hash) }
    specify { expect(subject[:branch][:source_branch][:repo][:id]).to be_a(Fixnum) }
    specify { expect(subject[:commands]).to be_a(Array) }
  end
end
