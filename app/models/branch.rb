class Branch < ActiveRecord::Base

  attr_accessible :github_url, :lighthouse_url, :source, :title

  belongs_to :repo
  belongs_to :user

  validates_uniqueness_of :name, scope: [ :source, :user_id ]

  def create_from_params(params)
    return unless new_record?

    self.repo = Repo.where(
      name: params[:repo][:name]
    ).first_or_initialize

    self.repo.user = User.where(
      login: params[:repo][:user]
    ).first_or_create

    # TODO: owner

    update_attributes(
      github_url:     params[:github_url],
      lighthouse_url: params[:lighthouse_url],
      source:         params[:source],
      title:          params[:title]
    )
  end
end
