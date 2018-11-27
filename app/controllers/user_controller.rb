# frozen_string_literal: true

class UserController < ApplicationController
  before_action :check_info_server_request, only: [:new_user]
  before_action :authenticate_user!, only: [:details]

  def details
    render json: current_user
  end

  def new_user
    result, user_or_error = add_new_user(user_params)

    case result
    when :invalid_data, :database_error
      render json: { errors: user_or_error }
    when :ok
      render json: { result: result }
    else
      render json: { error: :server_error }
    end
  end

  private

  def is_unique_uid(uid)
    if User.find_by(uid: uid)
      false
    else
      true
    end
  end

  def get_new_uid
    uid = Random.rand(1_000_000)
    uid = Random.rand(1_000_000) until is_unique_uid(uid)
    uid
  end

  def add_new_user(attrs)
    user = User.new(attrs)
    user.uid = get_new_uid

    return [:invalid_data, user.errors] unless user.valid?
    return [:database_error, user.errors] unless user.save

    [:ok, user]
  end

  def user_params
    params.require('payload').permit('address')
  end
end
