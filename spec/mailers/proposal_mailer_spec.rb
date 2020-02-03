# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProposalMailer' do
  describe '#received_proposal' do
    it 'should send a email to a candidate' do
      create(:job_vacancy)
      candidate = create(:candidate, email: 'usuario@usuario.com.br')
      create(:profile, candidate: candidate)
      registered = create(:registered, candidate: candidate)
      proposal = create(:proposal, registered: registered)
      email = ProposalMailer.received_proposal(proposal.id)

      expect(email.to).to include('usuario@usuario.com.br')
    end

    it 'should sendo a email from a headhunter' do
      create(:job_vacancy)
      profile = create(:profile)
      registered = create(:registered, candidate: profile.candidate)
      proposal = create(:proposal, registered: registered)
      email = ProposalMailer.received_proposal(proposal.id)

      expect(email.from).to include('no-reply@tpf.com.br')
    end

    it 'should send a email with a subtitle' do
      create(:job_vacancy)
      profile = create(:profile)
      registered = create(:registered, candidate: profile.candidate)
      proposal = create(:proposal, registered: registered)
      email = ProposalMailer.received_proposal(proposal.id)

      expect(email.subject).to eq('Proposta enviada para seu perfil!')
    end

    it 'shoudl send a email with a body' do
      job_vacancy = create(:job_vacancy, title: 'Vaga programador Ruby')
      profile = create(:profile, name: 'Fulano da Silva')
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy)
      proposal = create(:proposal, registered: registered,
                                   start_date: 30.days.from_now,
                                   limit_feedback_date: 7.days.from_now)
      email = ProposalMailer.received_proposal(proposal.id)

      expect(email.body).to include(
        'Olá Fulano da Silva, você acaba de receber uma proposta para a vaga: Vaga programador Ruby.'
      )
      expect(email.body).to include(
        "O inicio das atividades esta prevista para : #{I18n.l(30.days.from_now, format: '%d/%m/%Y')}."
      )
      expect(email.body).to include(
        'Acesse seu usuário para mais informações sobre a proposta.'
      )
      expect(email.body).to include(
        "ATENÇÃO: Você tem ate dia #{I18n.l(7.days.from_now, format: '%d/%m/%Y')} para responder a proposta, caso contrario ela sera encerrada."
      )
    end
  end
end
