# frozen_string_literal: true

module Types
  module User
    class UserType < Types::Base::BaseObject
      description 'DAO users who publish proposals and vote for them'

      field :address, Types::Scalar::EthAddress,
            null: false,
            description: <<~EOS
              User's ethereum address.

              This may be deprecated or a privacy leak so it should not be depended on.
            EOS
      field :display_name, String,
            null: false,
            description: <<~EOS
              Display name of the user which should be used to identify the user.
               This is just username if it is set; otherwise, this is just `user<id>`.
            EOS
      field :reputation_point, Types::Scalar::BigNumber,
            null: false,
            description: <<~EOS
              The user's reputation in participating in the system.
            EOS
      field :quarter_point, Types::Scalar::BigNumber,
            null: false,
            description: <<~EOS
              The user's accumulated points in the quarter.
            EOS

      def display_name
        object['username'].nil? ? "user#{object['uid']}" : object['username']
      end

      def quarter_point
        Types::Proposal::LazyPoints.new(context, object, :quarter_point)
      end

      def reputation_point
        Types::Proposal::LazyPoints.new(context, object, :reputation_point)
      end
    end
  end
end
