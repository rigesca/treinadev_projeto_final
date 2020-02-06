# frozen_string_literal: true

require 'rails_helper'

feature 'Headhunter list candidates from a vacancy' do
  scenario 'successfully' do
    headhunter = create(:headhunter)
    profile = create(:profile, :with_photo, name: 'Fulano da Silva',
                                            birth_date: 20.years.ago)
    job_vacancy = create(:job_vacancy, headhunter: headhunter)

    create(:registered, candidate: profile.candidate,
                        job_vacancy_id: job_vacancy.id,
                        registered_justification: 'Acho que sou '\
                        'qualificado para a vaga')

    login_as(headhunter, scope: :headhunter)

    visit root_path
    click_on 'Vagas'
    click_on job_vacancy.heading
    click_on 'Lista Candidatos'

    expect(page).to have_content('Fulano da Silva - 20 Anos')
    expect(page).to have_content('Acho que sou qualificado para a vaga')
  end

  scenario 'and has many candidates' do
    headhunter = create(:headhunter)

    first_profile = create(:profile, :with_photo, name: 'Fulano da Silva',
                                                  birth_date: 25.years.ago)
    second_profile = create(:profile, :with_photo, name: 'Siclano Alves',
                                                   birth_date: 37.years.ago)
    third_profile = create(:profile, :with_photo, name: 'Beltrano Carvalho',
                                                  birth_date: 18.years.ago)

    job_vacancy = create(:job_vacancy, headhunter: headhunter)

    create(:registered, candidate: first_profile.candidate,
                        job_vacancy: job_vacancy,
                        registered_justification: 'Sou Fulano da Silva e estou'\
                        ' preparado para exercer esse cargo na empresa')
    create(:registered, candidate: second_profile.candidate,
                        job_vacancy: job_vacancy,
                        registered_justification: 'Sou Siclano Alves estou '\
                        'preparado para exercer esse cargo na empresa')
    create(:registered, candidate: third_profile.candidate,
                        job_vacancy: job_vacancy,
                        registered_justification: 'Sou Beltrano Carvalho estou'\
                        ' preparado para exercer esse cargo na empresa')

    login_as(headhunter, scope: :headhunter)

    visit job_vacancy_path(job_vacancy)

    click_on 'Lista Candidatos'

    expect(page).to have_content('Fulano da Silva - 25 Anos')
    expect(page).to have_content('Sou Fulano da Silva e estou preparado para '\
      'exercer esse cargo na empresa')

    expect(page).to have_content('Siclano Alves - 37 Anos')
    expect(page).to have_content('Sou Siclano Alves estou preparado para '\
      'exercer esse cargo na empresa')

    expect(page).to have_content('Beltrano Carvalho - 18 Anos')
    expect(page).to have_content('Sou Beltrano Carvalho estou preparado para '\
      'exercer esse cargo na empresa')
  end

  scenario 'and has no registered candidates' do
    headhunter = create(:headhunter)
    job_vacancy = create(:job_vacancy, headhunter: headhunter)

    login_as(headhunter, scope: :headhunter)

    visit candidate_list_job_vacancy_path(job_vacancy.id)

    expect(page).to have_content('A vaga não possui candidatos.')
  end

  scenario 'and has no favorit registered candidates' do
    headhunter = create(:headhunter)
    job_vacancy = create(:job_vacancy, headhunter: headhunter)

    login_as(headhunter, scope: :headhunter)

    visit candidate_list_job_vacancy_path(job_vacancy.id)

    expect(page).to have_content('A vaga não possui candidatos em destaque.')
  end

  scenario 'and has no canceled registered' do
    headhunter = create(:headhunter)
    job_vacancy = create(:job_vacancy, headhunter: headhunter)

    login_as(headhunter, scope: :headhunter)

    visit candidate_list_job_vacancy_path(job_vacancy.id)

    expect(page).to have_content('A vaga não possui candidatos recusados.')
  end

  context 'route access test' do
    scenario 'a no-authenticate usser try to access candidate list option' do
      headhunter = create(:headhunter)
      job_vacancy = create(:job_vacancy, headhunter: headhunter)

      visit candidate_list_job_vacancy_path(job_vacancy)

      expect(current_path).to eq(new_headhunter_session_path)
    end
  end
end
