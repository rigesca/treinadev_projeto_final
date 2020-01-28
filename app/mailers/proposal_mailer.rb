class ProposalMailer < ApplicationMailer

    default from: 'no-reply@tpf.com.br'

    def received_proposal(proposal_id)
        @proposal = Proposal.find(proposal_id)

        candidate = @proposal.registered.candidate

        @name = candidate.profile.name
        @job_vacancy_title = @proposal.registered.job_vacancy.title

        mail(to: candidate.email, 
            subject: 'Proposta enviada para seu perfil!')
    end
end