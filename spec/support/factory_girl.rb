require "factory_girl"

FactoryGirl.define do
  factory :branch do
    name   { "#{prefix}name" }
    source { "#{prefix}source" }
    title  { "#{prefix}title" }

    association(:repo, prefix: "repo:")

    ignore { prefix "" }
  end

  factory :repo do
    name   { "#{prefix}name" }

    association(:owner, factory: :user, prefix: "repo:owner:")
    association(:user, prefix: "repo:user:")

    ignore { prefix "" }
  end

  factory :user do
    sequence(:github) { |n| n.to_s * 40 }
    login  { "#{prefix}login" }
    name   { "#{prefix}name" }

    ignore do
      login_prefix ""
      prefix       ""
      lighthouse_users_count 1
    end

    after(:create) do |user, evaluator|
      FactoryGirl.create_list(:lighthouse_user,
        evaluator.lighthouse_users_count,
        user: user
      )
    end
  end

  factory :lighthouse_user do
    sequence(:lighthouse_id)
    
    namespace { "#{prefix}namespace" }
    token     { "#{prefix}token" }

    user

    ignore { prefix "" }
  end
end