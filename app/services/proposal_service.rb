class ProposalService
  attr_reader :proposal

  def initialize(proposal)
    @proposal = proposal
  end

  def rejected_proposal(feedback)
    feedback = 'Proposta rejeitada pelo candidato' if feedback.blank?

    @proposal.update(feedback: feedback)

    @proposal.rejected!
    @proposal.registered.reject_proposal!
  end

  def accepted_proposal(feedback)
    feedback = 'Proposta aceita pelo candidato' if feedback.blank?

    @proposal.update(feedback: feedback)

    @proposal.accepted!
    @proposal.registered.accept_proposal!

    close_other_proposals(@proposal.candidate_id)
  end

  def close_other_proposals(candidate)
    Registered.candidate_registereds(candidate).each do |register|
      register.reject_proposal!
      register.update(
        closed_feedback: 'Um candidato já foi selecionado para essa vaga'
      )
      register.proposal.destroy if register.proposal.present?
    end
  end
end
