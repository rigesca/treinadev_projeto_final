# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :validate_profile!

  def index
    if current_candidate.present?
      quant_proposal = Proposal.joins(:registered).where('registereds.candidate_id = ? and proposals.status = 0', current_candidate.id).count

      if quant_proposal > 0
        flash.now[:notice] = "Você possui (#{quant_proposal}) propostas não analisadas ainda."
      end
    end
  end
end
