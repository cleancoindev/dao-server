# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :check_info_server_request, only: %i[confirmed latest test_server]
  after_action :update_info_server_nonce, only: %i[confirmed latest test_server]
  before_action :authenticate_user!, only: %i[new list]

  def confirmed
    body = JSON.parse(request.raw_post)
    txhashes = body['payload'].map { |e| e['txhash'] }
    Transaction.where(txhash: txhashes).update_all(status: 'confirmed')

    render json: { result: :ok,
                   msg: 'correct' }
  end

  def latest
    body = JSON.parse(request.raw_post)
    blockNumber = body['payload']['blockNumber']
    latestTxns = body['payload']['transactions']

    unless latestTxns.empty?
      Transaction.where(txhash: latestTxns).update_all(blockNumber: blockNumber, status: 'seen')
    end

    render json: { result: :ok,
                   msg: 'correct' }
  end

  def new
    result, transaction_or_error = add_new_transaction(current_user, transactions_params)

    case result
    when :invalid_data, :database_error
      render json: { errors: transaction_or_error }
    when :ok
      InfoServer.update_hashes([transaction_or_error.txhash.downcase])

      render json: { result: result,
                     tx: transaction_or_error }
    else
      render json: { error: :server_error }
    end
  end

  def list
    render json: { transactions: current_user.transactions }
  end

  def status
    # TODO: sanitize
    transaction = Transaction.find_by(txhash: params[:txhash])
    transaction || (return error_response('notFound'))
    render json: transaction
  end

  def test_server
    puts "body from test_server: #{request.body}"

    render json: {  result: :ok,
                    msg: 'correct' }
  end

  private

  def add_new_transaction(user, attrs)
    transaction = Transaction.new(attrs)
    transaction.user = user

    return [:invalid_data, transaction.errors] unless transaction.valid?

    transaction.txhash = transaction.txhash.downcase

    return [:database_error, transaction.errors] unless transaction.save

    [:ok, transaction]
  end

  def check_transactions_params
    params.require(:txhash)
    params.permit(:title)
  end

  def transactions_params
    params.permit(:title, :txhash)
  end
end
