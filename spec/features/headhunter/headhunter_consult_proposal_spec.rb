# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter consults a proposal' do
  context 'from proposal' do
    scenario 'successfully' do
      headhunter = create(:headhunter)
      profile = create(:profile, :with_photo, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :junior,
                                         headhunter: headhunter)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal,
                                       registered_justification: 'Estou preparado para exercer esse cargo na empresa')
      create(:proposal, start_date: 15.days.from_now,
                        limit_feedback_date: 7.days.from_now,
                        registered: registered)

      login_as(headhunter, scope: :headhunter)

      visit root_path
      click_on 'Propostas'

      expect(page).to have_content('Proposta enviada para: Fulano da Silva')
      expect(page).to have_content('Vaga : Júnior | Vaga de Ruby')
      expect(page).to have_content(
        "Data limite para resposta: #{I18n.localize(7.days.from_now, format: '%d/%m/%Y')}"
      )
      expect(page).to have_link('Analisar proposta')
      expect(page).to have_content('Enviada')
    end

    scenario 'and saw a proposal' do
      headhunter = create(:headhunter)
      profile = create(:profile, :with_photo, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :junior,
                                         vacancy_description: 'O candidato ira atuar programando em Ruby',
                                         headhunter: headhunter)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal,
                                       registered_justification: 'Estou preparado para exercer esse cargo na empresa')
      create(:proposal, start_date: 15.days.from_now,
                        limit_feedback_date: 7.days.from_now,
                        salary: 2500,
                        benefits: 'VR, VT, convenio e participação nos lucros.',
                        registered: registered)

      login_as(headhunter, scope: :headhunter)

      visit root_path

      click_on 'Propostas'
      click_on 'Analisar proposta'

      expect(page).to have_content('Júnior | Vaga de Ruby')
      expect(page).to have_content('Descrição da vaga: O candidato ira atuar programando em Ruby')

      expect(page).to have_content('Fulano da Silva')

      expect(page).to have_content('Proposta Enviada')
      expect(page).to have_content("Data para inicio das atividades: #{I18n.localize(15.days.from_now, format: '%d/%m/%Y')}")
      expect(page).to have_content("Data limite para resposta: #{I18n.localize(7.days.from_now, format: '%d/%m/%Y')}")
      expect(page).to have_content('Salário: R$ 2.500,00')
      expect(page).to have_content('Benefícios: VR, VT, convenio e participação nos lucros.')
    end

    scenario 'and saw a reject proposal' do
      headhunter = create(:headhunter)
      profile = create(:profile, :with_photo, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :full,
                                         vacancy_description: 'O candidato ira atuar programando em Ruby',
                                         headhunter: headhunter)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal,
                                       registered_justification: 'Estou preparado para exercer esse cargo na empresa')
      create(:proposal, start_date: 15.days.from_now,
                        limit_feedback_date: 7.days.from_now,
                        salary: 2500,
                        benefits: 'VR, VT, convenio e participação nos lucros.',
                        status: :rejected,
                        registered: registered)

      login_as(headhunter, scope: :headhunter)

      visit root_path
      click_on 'Propostas'

      expect(page).to have_content('Proposta enviada para: Fulano da Silva')
      expect(page).to have_content('Vaga : Pleno | Vaga de Ruby')
      expect(page).to have_link('Analisar proposta')
      expect(page).to have_content('Rejeitada')
    end

    scenario 'and saw a accept proposal' do
      headhunter = create(:headhunter)
      profile = create(:profile, :with_photo, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :manager,
                                         vacancy_description: 'O candidato ira atuar programando em Ruby',
                                         headhunter: headhunter)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :accept_proposal,
                                       registered_justification: 'Estou preparado para exercer esse cargo na empresa')
      create(:proposal, start_date: 15.days.from_now,
                        limit_feedback_date: 7.days.from_now,
                        salary: 2500,
                        benefits: 'VR, VT, convenio e participação nos lucros.',
                        status: :accepted,
                        registered: registered)

      login_as(headhunter, scope: :headhunter)

      visit root_path
      click_on 'Propostas'

      expect(page).to have_content('Proposta enviada para: Fulano da Silva')
      expect(page).to have_content('Vaga : Diretor | Vaga de Ruby')
      expect(page).to have_link('Analisar proposta')
      expect(page).to have_content('Aceita')
    end

    scenario 'and saw a expired proposal' do
      headhunter = create(:headhunter)
      profile = create(:profile, :with_photo, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :senior,
                                         vacancy_description: 'O candidato ira atuar programando em Ruby',
                                         headhunter: headhunter)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       registered_justification: 'Estou preparado para exercer esse cargo na empresa')
      create(:proposal, start_date: 15.days.from_now,
                        limit_feedback_date: 7.days.from_now,
                        salary: 2500,
                        benefits: 'VR, VT, convenio e participação nos lucros.',
                        status: :expired,
                        registered: registered)

      login_as(headhunter, scope: :headhunter)

      visit root_path
      click_on 'Propostas'

      expect(page).to have_content('Proposta enviada para: Fulano da Silva')
      expect(page).to have_content('Vaga : Sênior | Vaga de Ruby')
      expect(page).to have_link('Analisar proposta')
      expect(page).to have_content('Expirado')
    end
  end

  context 'from vacancy' do
    scenario 'successfully' do
      headhunter = create(:headhunter)
      profile = create(:profile, :with_photo, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, title: 'Vaga de Ruby',
                                         level: :junior,
                                         vacancy_description: 'O candidato ira atuar programando em Ruby',
                                         headhunter: headhunter)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy,
                                       status: :proposal,
                                       registered_justification: 'Estou preparado para exercer esse cargo na empresa')
      proposal = create(:proposal, start_date: 15.days.from_now,
                                   limit_feedback_date: 7.days.from_now,
                                   salary: 2500,
                                   benefits: 'VR, VT, convenio e participação nos lucros.',
                                   registered: registered)

      login_as(headhunter, scope: :headhunter)

      visit root_path
      click_on 'Vagas'
      click_on job_vacancy.heading
      click_on 'Lista Candidatos'

      page.find("##{proposal.id}_show_proposal").click

      expect(page).to have_content('Júnior | Vaga de Ruby')
      expect(page).to have_content('Descrição da vaga: O candidato ira atuar programando em Ruby')

      expect(page).to have_content('Fulano da Silva')

      expect(page).to have_content('Proposta Enviada')
      expect(page).to have_content("Data para inicio das atividades: #{I18n.localize(15.days.from_now, format: '%d/%m/%Y')}")
      expect(page).to have_content("Data limite para resposta: #{I18n.localize(7.days.from_now, format: '%d/%m/%Y')}")
      expect(page).to have_content('Salário: R$ 2.500,00')
      expect(page).to have_content('Benefícios: VR, VT, convenio e participação nos lucros.')
    end
  end

  scenario 'and try to consult a proposal from another headhunter' do
    first_headhunter = create(:headhunter)
    second_headhunter = create(:headhunter)

    profile = create(:profile, :with_photo)

    job_vacancy = create(:job_vacancy, headhunter: first_headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy,
                                     status: :proposal,
                                     registered_justification: 'Estou preparado para exercer esse cargo na empresa')

    proposal = create(:proposal, registered: registered)

    login_as(second_headhunter, scoope: :headhunter)

    visit proposal_path(proposal)

    expect(current_path).to eq(root_path)
  end
end
