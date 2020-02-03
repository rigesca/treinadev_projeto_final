# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter rejects a candidate' do
  scenario 'successfully' do
    headhunter = create(:headhunter)
    profile = create(:profile, name: 'Fulano da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)

    login_as(headhunter, scope: :headhunter)

    visit root_path
    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'

    page.find("##{registered.id}_canceled").click
    fill_in 'Feedback', with: 'Candidato foi encerrado devido não ter todas as habilidades necessarias.'

    click_on 'Encerrar'

    expect(page).to have_content(
      'Candidato Fulano da Silva teve sua participação finalizada com sucesso'
    )

    registered.reload

    expect(registered.status).to eq('excluded')
    expect(page).to have_content("Feedback:#{registered.closed_feedback}")
  end

  scenario 'and try to closed a registered without fill justification' do
    headhunter = create(:headhunter)
    profile = create(:profile)
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)

    login_as(headhunter, scope: :headhunter)

    visit candidate_list_job_vacancy_path(job_vacancy.id)
    page.find("##{registered.id}_canceled").click

    click_on 'Encerrar'

    expect(page).to have_content('Campo Feedback não pode ser vazio')
    expect(registered.status).to eq('in_progress')
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access reject registered option' do
      headhunter = create(:headhunter)
      profile = create(:profile, name: 'Fulano da Silva')
      job_vacancy = create(:job_vacancy, headhunter: headhunter)
      registered = create(:registered, candidate: profile.candidate,
                                       job_vacancy: job_vacancy)

      visit cancel_registered_path(registered)

      expect(current_path).to eq(new_headhunter_session_path)
    end
  end
end
