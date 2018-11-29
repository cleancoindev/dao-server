# frozen_string_literal: true

class ProposalsController < ApplicationController
  around_action :check_and_update_info_server_request, only: %i[create]

  def create
    result, proposal_or_error = Proposal.create_proposal(create_params)

    case result
    when :invalid_data, :database_error
      render json: error_response(proposal_or_error)
    when :ok
      render json: result_response(proposal_or_error)
    end
  end

  def find
  end

  def create_params
    params.permit(:proposal_id, :proposer)
  end
end
