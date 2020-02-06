# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter make a proposal to a candidate' do
  scenario 'successfully' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)
    login_as(headhunter, scope: :headhunter)

    visit root_path
    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'

    page.find("##{registered.id}_create_proposal").click

    fill_in 'Salário', with: 2600
    fill_in 'Data de inicio das atividades', with: 15.days.from_now
    fill_in 'Data limite para a resposta a proposta', with: 7.days.from_now
    fill_in 'Benefícios', with: 'Vale transporte, vale refeição,'\
    ' convenio medico e dentario.'
    fill_in 'Observações', with: 'O candidato devera usar roupas formais '\
    'de segunda a quinta feita.'

    click_on 'Enviar'

    expect(page).to have_content(
      'Proposta enviada ao candidato Fulano da Silva com sucesso'
    )
    expect(page).not_to have_link("##{registered.id}_create_proposal")

    registered.reload

    expect(registered.status).to eq('proposal')
  end

  scenario 'a valid proposal send a email to candidate' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)

    mailer_spy = class_spy(ProposalMailer)
    stub_const('ProposalMailer', mailer_spy)

    login_as(headhunter, scope: :headhunter)

    visit proposal_registered_path(registered)

    fill_in 'Salário', with: 2600
    fill_in 'Data de inicio das atividades', with: 15.days.from_now
    fill_in 'Data limite para a resposta a proposta', with: 7.days.from_now
    fill_in 'Benefícios', with: 'Vale transporte, vale refeição,'\
    ' convenio medico e dentario.'
    fill_in 'Observações', with: 'O candidato devera usar roupas formais de'\
    ' segunda a quinta feita.'

    click_on 'Enviar'

    proposal = Proposal.last

    expect(ProposalMailer).to have_received(:received_proposal).with proposal.id
  end

  scenario 'and try to make a proposal witout a note' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)
    login_as(headhunter, scope: :headhunter)

    visit proposal_registered_path(registered)

    fill_in 'Salário', with: 2600
    fill_in 'Data de inicio das atividades', with: 14.days.from_now
    fill_in 'Data limite para a resposta a proposta', with: 7.days.from_now
    fill_in 'Benefícios', with: 'Vale transporte, vale refeição,'\
    ' convenio medico e dentario.'

    click_on 'Enviar'

    expect(page).to have_content(
      'Proposta enviada ao candidato Fulano da Silva com sucesso'
    )
    expect(page).not_to have_link("##{registered.id}_create_proposal")
  end

  scenario 'and try to make a proposal without filling in all fields' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)
    login_as(headhunter, scope: :headhunter)

    visit proposal_registered_path(registered)

    click_on 'Enviar'

    expect(page).to have_content('Data inicial não pode ficar em branco')
    expect(page).to have_content('Salário não pode ficar em branco')
    expect(page).to have_content('Benefícios não pode ficar em branco')
    expect(page).to have_content(
      'Data limite para resposta não pode ficar em branco'
    )
  end

  scenario 'and try to make a proposal with a invalid salary' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)
    login_as(headhunter, scope: :headhunter)

    visit proposal_registered_path(registered)

    fill_in 'Salário', with: '2a100'
    fill_in 'Data de inicio das atividades', with: 14.days.from_now
    fill_in 'Data limite para a resposta a proposta', with: 7.days.from_now
    fill_in 'Benefícios', with: 'Vale transporte, vale refeição,'\
    ' convenio medico e dentario.'

    click_on 'Enviar'

    expect(page).to have_content('Salário não é um número')
  end

  scenario 'and try to make a proposal with a lower starting date than today' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)

    login_as(headhunter, scope: :headhunter)

    visit proposal_registered_path(registered)

    fill_in 'Salário', with: 2600
    fill_in 'Data de inicio das atividades', with: Date.current.prev_day(15)
    fill_in 'Benefícios', with: 'Vale transporte, vale refeição,'\
    ' convenio medico e dentario.'
    click_on 'Enviar'

    expect(page).to have_content('Data inicial deve ser maior que a data atual')
  end

  scenario 'and try to make a proposal with a lower salary than salary range' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter,
                                       maximum_wage: 3000,
                                       minimum_wage: 2500)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)
    login_as(headhunter, scope: :headhunter)

    visit proposal_registered_path(registered)

    fill_in 'Salário', with: 1500
    fill_in 'Data de inicio das atividades', with: 15.days.from_now
    fill_in 'Data limite para a resposta a proposta', with: 7.days.from_now
    fill_in 'Benefícios', with: 'Vale transporte, vale refeição,'\
    ' convenio medico e dentario.'
    click_on 'Enviar'

    expect(page).to have_content(
      'Salário o valor deve estra dentro da faixa estipulado pela vaga.'
    )
  end

  scenario 'and try create proposal with a bigger salary than salary range' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter,
                                       maximum_wage: 3000,
                                       minimum_wage: 2500)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)
    login_as(headhunter, scope: :headhunter)

    visit proposal_registered_path(registered)

    fill_in 'Salário', with: 3200
    fill_in 'Data de inicio das atividades', with: 15.days.from_now
    fill_in 'Data limite para a resposta a proposta', with: 7.days.from_now
    fill_in 'Benefícios', with: 'Vale transporte, vale refeição,'\
    ' convenio medico e dentario.'
    click_on 'Enviar'

    expect(page).to have_content(
      'Salário o valor deve estra dentro da faixa estipulado pela vaga.'
    )
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access new option' do
      headhunter = create(:headhunter)
      profile = create(:profile, :with_photo, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, headhunter: headhunter,
                                         maximum_wage: 3000,
                                         minimum_wage: 2500)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy)

      proposal = create(:proposal, registered: registered)

      visit proposal_registered_path(proposal)

      expect(current_path).to eq(new_headhunter_session_path)
    end
  end
end
