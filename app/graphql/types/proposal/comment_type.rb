# frozen_string_literal: true

module Types
  module Proposal
    class CommentType < Types::Base::BaseObject
      description 'Comments/messages between voters for proposals'

      field :id, ID,
            null: false,
            description: 'Comment ID'
      field :stage, Types::Enum::ProposalStageEnum,
            null: false,
            description: 'Stage/phase the comment was published'
      field :body, String,
            null: true,
            description: <<~EOS
              Message/body of the comment.
               This is `null` if this message is deleted or banned.
            EOS
      field :is_banned, Boolean,
            null: true,
            description: <<~EOS
              A flag indicating if the comment is banned.

              Can only be seen by a `Forum Admin`, otherwise `null`
            EOS

      field :likes, Integer,
            null: true,
            description: 'Number of user who liked this comment. Also, `null` if no current user.'
      field :liked, Boolean,
            null: true,
            description: <<~EOS
              A flag to indicate if the current user liked this comment. Also, `null` if no current user.
            EOS

      field :created_at, GraphQL::Types::ISO8601DateTime,
            null: false,
            description: 'Date when the comment was published'

      field :parent_id, String,
            null: false,
            description: 'Parent id of the comment'
      field :user, Types::User::UserType,
            null: false,
            description: 'Poster of this comment'

      REPLY_DESCRIPTION = <<~EOS
        Replies/comments about this comment.

         Given a parent comment, comment threads are list of parent comment replies
         and the reply of those replies and so on.

         Since this is designed with a load more functionality,
         this uses Relay connection pagination.
      EOS
      field :replies, CommentThreadConnectionType,
            connection: false,
            null: false,
            description: REPLY_DESCRIPTION do
        argument :first, Int,
                 required: false,
                 default_value: 10,
                 description: 'Returns the first _n_ elements from the list.'
      end

      def body
        this_body, is_discarded, is_banned =
          if object.is_a?(Comment)
            [object.body, object.discarded?, object.is_banned]
          else
            [object['body'], object['discarded_at'].nil?, object['is_banned']]
          end

        return this_body if context.fetch(:current_user)&.is_forum_admin? && is_banned

        is_discarded ? nil : this_body
      end

      def is_banned
        context.fetch(:current_user)&.is_forum_admin? ?
          object.is_banned : nil
      end

      def likes
        object.likes if context.fetch(:current_user, nil)
      end

      def liked
        object.liked || !object.comment_like_id.nil? if context.fetch(:current_user, nil)
      end

      def replies(first:)
        Types::Proposal::LazyCommentThread.new(context, object, first)
      end
    end
  end
end
