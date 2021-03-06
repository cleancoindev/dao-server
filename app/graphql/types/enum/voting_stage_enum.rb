# frozen_string_literal: true

module Types
  module Enum
    class VotingStageEnum < Types::Base::BaseEnum
      description 'Phases for a voting round'

      value 'DRAFT', 'The proposal is being drafted or finalized',
            value: 'draftVoting'
      value 'COMMIT', 'Voters commit to a vote',
            value: 'commit'
      value 'REVEAL', 'Voters reveal their vote',
            value: 'reveal'
    end
  end
end
