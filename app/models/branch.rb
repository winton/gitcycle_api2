class Branch < ActiveRecord::Base

  after_commit :update_from_ticket
  after_save   :update_from_ticket  if Rails.env == 'test'

  attr_accessible :github_url, :lighthouse_url, :source, :title

  belongs_to :repo
  belongs_to :user

  validates_uniqueness_of :name, scope: [ :source, :user_id ]

  class <<self
    def find_from_params(params, user)
      if params[:name]
        Branch.where(
          name:    params[:name],
          user_id: user.id
        ).first_or_initialize
      elsif params[:source]
        Branch.where(
          source:  params[:source],
          user_id: user.id
        ).first_or_initialize
      end
    end
  end

  def create_from_params(params)
    return unless new_record?

    self.repo = Repo.where(
      name: params[:repo][:name]
    ).first_or_initialize

    self.repo.user = User.where(
      login: params[:repo][:user][:login]
    ).first_or_create

    update_attributes(
      github_url:     params[:github_url],
      lighthouse_url: params[:lighthouse_url],
      source:         params[:source],
      title:          params[:title]
    )
  end

  def update_from_ticket
    return  if name && title
    update_from_lighthouse  if lighthouse_url
  end

  def update_from_lighthouse
    lh_user = user.lighthouse_user_from_url(lighthouse_url)
    return  unless lh_user

    ticket = Lighthouse.new(lh_user).ticket(lighthouse_url)

    self.name  = ticket[:name]
    self.title = ticket[:title]

    save
  end
end
