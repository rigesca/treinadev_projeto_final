# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter closes job vacancy' do
  scenario 'successfully' do
    headhunter = create(:headhunter)

    first_profile = create(:profile)
    second_profile = create(:profile)
    third_profile = create(:profile)

    job_vacancy = create(:job_vacancy, headhunter_id: headhunter.id)

    registered = create(:registered, candidate: second_profile.candidate,
                                     job_vacancy: job_vacancy)
    accept_registered = create(:registered, candidate: first_profile.candidate,
                                            job_vacancy: job_vacancy,
                                            status: :accept_proposal)
    reject_registered = create(:registered, candidate: third_profile.candidate,
                                            job_vacancy_id: job_vacancy.id,
                                            status: :reject_proposal)

    create(:proposal, status: :rejected,
                      registered: reject_registered)

    create(:proposal, status: :accepted,
                      registered: accept_registered)

    login_as(headhunter, scope: :headhunter)
    visit root_path
    click_on 'Vagas'
    click_on job_vacancy.heading

    click_on 'Encerra vaga'

    expect(page).to have_content('Encerrada')
    expect(page).to have_no_link('Lista Candidatos')

    job_vacancy.reload
    expect(job_vacancy.status).to eq('closed')

    reject_registered.reload
    expect(reject_registered.status).to eq('closed')
    expect(reject_registered.proposal).to eq(nil)

    registered.reload
    expect(registered.status).to eq('closed')
  end

  scenario 'and others candidate register be closed' do
    profile = create(:profile, :with_photo)
    job_vacancy = create(:job_vacancy)

    create(:registered, candidate: profile.candidate,
                        job_vacancy: job_vacancy,
                        status: :closed)

    login_as(profile.candidate, scope: :candidate)
    visit root_path
    click_on 'Minhas Vagas'

    expect(page).to have_content('Encerrada')
    expect(page).to have_no_link(job_vacancy.heading)
    expect(page).to have_content('Vaga encerrada!')
  end
end
