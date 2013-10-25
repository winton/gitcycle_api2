require "factory_girl"

FactoryGirl.define do
  factory :branch do
    github_url     "https://github.com/login/repo/pull/0000"
    lighthouse_url "https://test.lighthouseapp.com/projects/0000/tickets/0000-ticket"
    name           "name"
    source         "source"
    title          "title"

    repo
  end

  factory :repo do
    name  "name"

    association :owner, factory: :user, login: "owner_login"
    user
  end

  factory :user do
    sequence(:github) { |n| n.to_s * 40 }
    login  "login"
    name   "name"
  end
end