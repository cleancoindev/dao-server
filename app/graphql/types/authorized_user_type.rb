# frozen_string_literal: true

module Types
  class AuthorizedUserType < Types::BaseObject
    description 'DAO users who publish proposals and vote for them'

    field :id, ID,
          null: false,
          description: "User's ID"
    field :address, String,
          null: false,
          description: "User's ethereum address"
    field :email, String,
          null: true,
          description: "User's email"
    field :username, String,
          null: true,
          description: "User's username"
    field :display_name, String,
          null: false,
          description: <<~EOS
            Display name of the user which should be used to identify the user.

            This is just username if it is set; otherwise, this is just `user<id>`.
          EOS
    field :created_at, GraphQL::Types::ISO8601DateTime,
          null: false,
          description: 'Date when the proposal was published'

    def display_name
      object.username.nil? ? "user#{object.uid}" : object.username
    end

    def self.authorized?(object, context)
      super && context.fetch(:current_user, nil)
    end
  end
end