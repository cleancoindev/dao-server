# frozen_string_literal: true

FactoryBot.define do
  sequence(:proposal_id) { |_| Random.rand(100..1000) }
  sequence(:proposal_stage) { |_| Proposal.stages.keys.sample }

  factory :proposal, class: 'Proposal' do
    stage { generate(:proposal_stage) }
    association :user, factory: :user

    factory :proposal_with_comments do
      transient do
        comment_count { 3 }
        comment_depth { 3 }
        comment_ratio { 67 }
      end
      after(:create) do |proposal, evaluator|
        comments = create_list(:comment, evaluator.comment_count, proposal: proposal)
        more_comments = comments
        depth = 0

        until more_comments.empty? || (depth >= evaluator.comment_depth)
          new_comments = []

          more_comments.each do |comment|
            create_list(:comment, evaluator.comment_count).each do |reply|
              comment.add_child(reply)

              new_comments.push(reply) if Random.rand(100) >= evaluator.comment_ratio
            end
          end

          depth += 1
          more_comments = new_comments
        end
      end
    end
  end

  factory :info_proposal, class: 'Object' do
    proposal_id { generate(:proposal_id) }
    proposer { generate(:address) }
  end
end
