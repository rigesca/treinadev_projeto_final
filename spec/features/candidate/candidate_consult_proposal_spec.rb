# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate consults a proposal' do
  context 'from my proposal' do
    scenario 'successfully' do
      headhunter = create(:headhunter, email: 'headhunter@gmail.com')

      profile = create(:profile, :with_photo)

      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :junior,
                                         headhunter: headhunter)

      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal)

      create(:proposal, limit_feedback_date: 7.days.from_now,
                        registered: registered)

      login_as(profile.candidate, scope: :candidate)

      visit root_path
      click_on 'Minhas propostas'

      expect(page).to have_content('Proposta enviada por: headhunter@gmail.com')
      expect(page).to have_content('Vaga : Júnior | Vaga de Ruby')
      expect(page).to have_content(
        'Data limite para resposta: '\
        "#{I18n.localize(7.days.from_now, format: '%d/%m/%Y')}"
      )
      expect(page).to have_link('Analisar proposta')
    end

    scenario 'and saw the proposal' do
      headhunter = create(:headhunter, email: 'headhunter@gmail.com')

      profile = create(:profile, :with_photo, name: 'Siclano de Tal')

      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         vacancy_description: 'Ira trabalhar '\
                                         'com TDD e Ruby',
                                         maximum_wage: 3000,
                                         minimum_wage: 2000,
                                         level: :junior,
                                         headhunter: headhunter)

      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal)

      create(:proposal, start_date: 30.days.from_now,
                        limit_feedback_date: 7.days.from_now,
                        benefits: 'VR,VT e convênio médico',
                        salary: 2500,
                        registered: registered)

      login_as(profile.candidate, scope: :candidate)

      visit root_path
      click_on 'Minhas propostas'
      click_on 'Analisar proposta'

      expect(page).to have_content('Júnior | Vaga de Ruby')
      expect(page).to have_content(
        'Descrição da vaga: Ira trabalhar com TDD e Ruby'
      )

      expect(page).to have_content('Siclano de Tal')

      expect(page).to have_content('Proposta Enviada')
      expect(page).to have_content(
        'Data para inicio das atividades: '\
        "#{I18n.localize(30.days.from_now, format: '%d/%m/%Y')}"
      )
      expect(page).to have_content(
        'Data limite para resposta: '\
        "#{I18n.localize(7.days.from_now, format: '%d/%m/%Y')}"
      )
      expect(page).to have_content('Salário: R$ 2.500,00')
      expect(page).to have_content('Benefícios: VR,VT e convênio médico')
    end

    scenario 'and had a reject proposal' do
      headhunter = create(:headhunter, email: 'headhunter@gmail.com')

      profile = create(:profile, :with_photo)

      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :junior,
                                         headhunter: headhunter)

      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal)

      create(:proposal, limit_feedback_date: 7.days.from_now,
                        status: :rejected,
                        registered: registered)

      login_as(profile.candidate, scope: :candidate)

      visit proposals_path

      expect(page).not_to have_content(
        'Proposta enviada por: headhunter@gmail.com'
      )
      expect(page).not_to have_content('Vaga : Júnior | Vaga de Ruby')
      expect(page).not_to have_content(
        'Data limite para resposta: '\
        "#{I18n.localize(7.days.from_now, format: '%d/%m/%Y')}"
      )
      expect(page).not_to have_link('Analisar proposta')
    end

    scenario 'and no have proposal' do
      profile = create(:profile, :with_photo)

      login_as(profile.candidate, scope: :candidate)

      visit proposals_path

      expect(page).to have_content('Não existem propostas para seu perfil')
    end
  end

  context 'from my job_vacancy' do
    scenario 'successfully' do
      profile = create(:profile, :with_photo)

      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :junior,
                                         vacancy_description: 'Ira trabalhar '\
                                         'com TDD e Ruby')

      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal)

      create(:proposal, limit_feedback_date: 7.days.from_now,
                        registered: registered)

      login_as(profile.candidate, scope: :candidate)

      visit root_path
      click_on 'Minhas Vagas'

      expect(page).to have_content('Júnior | Vaga de Ruby')
      expect(page).to have_content(
        'Descrição da vaga: Ira trabalhar com TDD e Ruby'
      )
      expect(page).to have_content('Proposta recebida !')
      expect(page).to have_link('Ver proposta')
    end

    scenario 'and saw the proposal' do
      headhunter = create(:headhunter, email: 'headhunter@gmail.com')

      profile = create(:profile, :with_photo, name: 'Siclano de Tal')

      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         vacancy_description: 'Ira trabalhar '\
                                         'com TDD e Ruby',
                                         maximum_wage: 3000,
                                         minimum_wage: 2000,
                                         level: :junior,
                                         headhunter: headhunter)

      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal)

      create(:proposal, start_date: 30.days.from_now,
                        limit_feedback_date: 7.days.from_now,
                        benefits: 'VR,VT e convênio médico',
                        salary: 2500,
                        registered: registered)

      login_as(profile.candidate, scope: :candidate)

      visit root_path
      click_on 'Minhas Vagas'
      click_on 'Ver proposta'

      expect(page).to have_content('Júnior | Vaga de Ruby')
      expect(page).to have_content(
        'Descrição da vaga: Ira trabalhar com TDD e Ruby'
      )

      expect(page).to have_content('Siclano de Tal')

      expect(page).to have_content('Proposta Enviada')
      expect(page).to have_content(
        'Data para inicio das atividades: '\
        "#{I18n.localize(30.days.from_now, format: '%d/%m/%Y')}"
      )
      expect(page).to have_content(
        'Data limite para resposta: '\
        "#{I18n.localize(7.days.from_now, format: '%d/%m/%Y')}"
      )
      expect(page).to have_content('Salário: R$ 2.500,00')
      expect(page).to have_content('Benefícios: VR,VT e convênio médico')
    end

    scenario 'and had a reject proposal' do
      headhunter = create(:headhunter, email: 'headhunter@gmail.com')

      profile = create(:profile, :with_photo)

      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :junior,
                                         headhunter: headhunter)

      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :reject_proposal)

      create(:proposal, limit_feedback_date: 7.days.from_now,
                        status: :rejected,
                        feedback: 'Busco oportunidades com salários maiores.',
                        registered: registered)

      login_as(profile.candidate, scope: :candidate)

      visit registereds_path

      expect(page).to have_content('Júnior | Vaga de Ruby')
      expect(page).to have_content('Proposta rejeitada')
      expect(page).to have_content(
        'Feedback do candidato: Busco oportunidades com salários maiores'
      )
    end
  end

  scenario 'and try to access a proposal from another candidate' do
    first_profile = create(:profile, :with_photo)

    second_profile = create(:profile, :with_photo)

    job_vacancy = create(:job_vacancy)

    second_registered = create(:registered, candidate: second_profile.candidate,
                                            job_vacancy: job_vacancy,
                                            status: :proposal)

    proposal = create(:proposal, registered: second_registered)

    login_as(first_profile.candidate, scope: :candidate)

    visit proposal_path(proposal)

    expect(current_path).to eq(root_path)
  end
end
