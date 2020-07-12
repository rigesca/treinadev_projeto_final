# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :validate_profile!

  def index
    return unless candidate_signed_in?

    amount = Proposal.all_candidate_proposal(current_candidate.id).count
    return unless amount.positive?

    flash.now[:notice] = t('message.proposal_notice', amount: amount)
  end
end
