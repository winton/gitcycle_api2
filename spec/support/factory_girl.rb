require "factory_girl"

FactoryGirl.define do
  factory :branch_base, class: Branch do
    name  { "#{prefix}name" }

    factory :branch do
      title { "#{prefix}title" }
      
      association(:repo, prefix: "repo:")
      association(:source_branch, prefix: "source_branch:")
      association(:user, prefix: "user:")
    end

    factory :source_branch do
      association(:repo, prefix: "source_branch:repo:", factory: :source_branch_repo)
    end

    ignore { prefix "" }
  end

  factory :repo do
    name   { "#{prefix}name" }
    ignore { prefix "" }

    association(:user, prefix: "repo:user:")
  end

  factory :source_branch_repo, class: Repo do
    name   { "#{prefix}name" }
    ignore { prefix "" }

    association(:user, prefix: "source_branch:repo:user:")
  end

  factory :user do
    sequence(:github) { |n| n.to_s * 40 }
    login  { "#{prefix}login" }
    name   { "#{prefix}name" }

    ignore do
      login_prefix ""
      prefix       "user:"
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