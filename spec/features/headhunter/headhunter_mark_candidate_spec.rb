# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter mark a candidate like a highlight' do
  scenario 'successfully' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano Da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'

    page.find("##{registered.id}_candidatos").click

    expect(page).to have_content(
      'Candidato Fulano Da Silva marcado como destaque com sucesso'
    )
    registered.reload
    expect(registered.checked?).to eq(true)
  end

  scenario 'and unchecked a candidate' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano Da Silva')
    job_vacancy = create(:job_vacancy, headhunter: headhunter)
    registered = create(:registered, candidate: profile.candidate,
                                     job_vacancy: job_vacancy,
                                     highlight: :checked)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'

    page.find("##{registered.id}_candidatos").click

    expect(page).to have_content(
      'Candidato Fulano Da Silva desmarcado como destaque com sucesso'
    )
    registered.reload
    expect(registered.unchecked?).to eq(true)
  end

  scenario 'and checked a candidate from a list of candidate' do
    headhunter = create(:headhunter)

    first_profile = create(:profile, :with_photo, name: 'Fulano Da Silva')
    second_profile = create(:profile, :with_photo, name: 'Siclano Moreira')
    third_profile = create(:profile, :with_photo, name: 'Beltrano de Oliveira')

    job_vacancy = create(:job_vacancy, headhunter: headhunter)

    first_registered = create(:registered, candidate: first_profile.candidate,
                                           job_vacancy: job_vacancy)
    second_registered = create(:registered, candidate: second_profile.candidate,
                                            job_vacancy: job_vacancy)
    third_registered = create(:registered, candidate: third_profile.candidate,
                                           job_vacancy: job_vacancy)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'

    page.find("##{second_registered.id}_candidatos").click

    expect(page).to have_content(
      'Candidato Siclano Moreira marcado como destaque com sucesso'
    )

    first_registered.reload
    second_registered.reload
    third_registered.reload

    expect(first_registered.unchecked?).to eq(true)
    expect(second_registered.checked?).to eq(true)
    expect(third_registered.unchecked?).to eq(true)
  end

  scenario 'and unchecked a candidate from a list of candidate' do
    headhunter = create(:headhunter)

    first_profile = create(:profile, :with_photo, name: 'Fulano Da Silva')
    second_profile = create(:profile, :with_photo, name: 'Siclano Moreira')
    third_profile = create(:profile, :with_photo, name: 'Beltrano de Oliveira')

    job_vacancy = create(:job_vacancy, headhunter: headhunter)

    first_registered = create(:registered, candidate: first_profile.candidate,
                                           job_vacancy: job_vacancy)
    second_registered = create(:registered, candidate: second_profile.candidate,
                                            job_vacancy: job_vacancy,
                                            highlight: :checked)
    third_registered = create(:registered, candidate: third_profile.candidate,
                                           job_vacancy: job_vacancy,
                                           highlight: :checked)

    login_as(headhunter, scope: :headhunter)

    visit root_path

    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'

    page.find("##{second_registered.id}_candidatos").click

    expect(page).to have_content(
      'Candidato Siclano Moreira desmarcado como destaque com sucesso'
    )

    first_registered.reload
    second_registered.reload
    third_registered.reload

    expect(first_registered.unchecked?).to eq(true)
    expect(second_registered.unchecked?).to eq(true)
    expect(third_registered.checked?).to eq(true)
  end
end
