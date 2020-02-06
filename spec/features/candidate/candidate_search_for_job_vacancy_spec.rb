# frozen_string_literal: true

require 'rails_helper'

feature 'Candidate search for a job vacancy' do
  context 'vacancies screen' do
    scenario 'and have some valide vacancies' do
      profile = create(:profile, :with_photo)
      create(:job_vacancy, title: 'Desenvolvedor Ruby',
                           level: :junior)

      create(:job_vacancy, title: 'Desenvolvedor Java',
                           level: :full)

      login_as(profile.candidate, scope: :candidate)

      visit root_path
      click_on 'Busca por vagas'

      expect(page).to have_content('Júnior | Desenvolvedor Ruby')
      expect(page).to have_content('Pleno | Desenvolvedor Java')
    end

    scenario 'and no have vacancy' do
      profile = create(:profile, :with_photo)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path

      expect(page).to have_content('Não existem vagas abertas no momento')
    end

    scenario 'and have a closed vacancy' do
      profile = create(:profile, :with_photo)
      create(:job_vacancy, status: :closed)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path

      expect(page).to have_content('Não existem vagas abertas no momento')
    end
  end

  context 'only a title' do
    scenario 'successfully' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby')

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java')

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack')

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de'\
        ' desenvolvimento de software')

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Busca por', with: 'fullstack'
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
    end

    scenario 'multiples results' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby')

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java')

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack')

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de'\
        ' desenvolvimento de software')

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Busca por', with: 'desen'
      click_on 'Pesquisar'

      expect(page).to have_content(first_vacancy.heading)
      expect(page).to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).to have_content(fourth_vacancy.heading)
    end

    scenario 'no result' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby')

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java')

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack')

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de'\
        ' desenvolvimento de software')

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Busca por', with: 'rails'
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
      expect(page).to have_content('Não existem vagas abertas no momento')
    end
  end

  context 'only a description' do
    scenario 'successfully' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           vacancy_description: 'O profissional'\
                                           ' ira trabalhar com ruby')
      second_vacancy= create(:job_vacancy, title: 'Desenvolvedor Java',
                                           vacancy_description: 'O profissional'\
                                           ' ira trabalhar com java e orientação a objeto')
      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           vacancy_description: 'O profissional'\
                                           ' ira trabalhar varias linguagens')
      fourth_vacancy= create(:job_vacancy, title: 'Gerente de projeto de '\
                                                   'desenvolvimento de software',
                                           vacancy_description: 'O profissional'\
                                           'ira trabalhar com varios projetos')

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Busca por', with: 'objeto'
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
    end

    scenario 'multiples results' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           vacancy_description: 'O profissional ira trabalhar com ruby')

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            vacancy_description: 'O profissional ira trabalhar com java e orientação a objeto')

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           vacancy_description: 'O profissional ira trabalhar varias linguagens, começando por ruby')

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            vacancy_description: 'O profissional ira trabalhar com varios projetos')

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Busca por', with: 'ruby'
      click_on 'Pesquisar'

      expect(page).to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
    end

    scenario 'no result' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           vacancy_description: 'O profissional ira trabalhar com ruby')

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            vacancy_description: 'O profissional ira trabalhar com java e orientação a objeto')

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           vacancy_description: 'O profissional ira trabalhar varias linguagens, começando por ruby')

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            vacancy_description: 'O profissional ira trabalhar com varios projetos')

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Busca por', with: '1991'
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
      expect(page).to have_content('Não existem vagas abertas no momento')
    end
  end

  context 'only level' do
    scenario 'successfully' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           level: :junior)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            level: :full)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           level: :specialist)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            level: :manager)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      find("[value='junior']").set(true)
      click_on 'Pesquisar'

      expect(page).to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
    end

    scenario 'multiples results' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           level: :junior)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            level: :full)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           level: :specialist)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            level: :manager)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      find("[value='full']").set(true)
      find("[value='specialist']").set(true)
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).to have_content(second_vacancy.heading)
      expect(page).to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
    end

    scenario 'no result' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           level: :junior)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            level: :full)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           level: :specialist)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            level: :manager)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      find("[value='trainee']").set(true)
      find("[value='senior']").set(true)
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
      expect(page).to have_content('Não existem vagas abertas no momento')
    end
  end

  context 'only value' do
    scenario 'successfully' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           minimum_wage: 2500,
                                           maximum_wage: 2800)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            minimum_wage: 2800,
                                            maximum_wage: 3200)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           minimum_wage: 5000,
                                           maximum_wage: 5800)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            minimum_wage: 3700,
                                            maximum_wage: 4200)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Valor minimo', with: 5000
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
    end

    scenario 'multiples results' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           minimum_wage: 2500,
                                           maximum_wage: 2800)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            minimum_wage: 2800,
                                            maximum_wage: 3200)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           minimum_wage: 5000,
                                           maximum_wage: 5800)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            minimum_wage: 3700,
                                            maximum_wage: 4200)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path
      fill_in 'Valor minimo', with: 3700
      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).to have_content(third_vacancy.heading)
      expect(page).to have_content(fourth_vacancy.heading)
    end

    scenario 'no result' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           minimum_wage: 2500,
                                           maximum_wage: 2800)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            minimum_wage: 2800,
                                            maximum_wage: 3200)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           minimum_wage: 5000,
                                           maximum_wage: 5800)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software',
                                            minimum_wage: 3700,
                                            maximum_wage: 4200)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path

      fill_in 'Valor minimo', with: 5500

      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
      expect(page).to have_content('Não existem vagas abertas no momento')
    end
  end

  context 'multiples search options' do
    scenario 'successfully' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           vacancy_description: 'O profissional ira trabalhar com ruby',
                                           level: :junior,
                                           minimum_wage: 2500,
                                           maximum_wage: 2800)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            vacancy_description: 'O profissional ira trabalhar com java e orientação a objeto',
                                            level: :full,
                                            minimum_wage: 2800,
                                            maximum_wage: 3200)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           vacancy_description: 'O profissional ira trabalhar varias linguagens',
                                           level: :specialist,
                                           minimum_wage: 5000,
                                           maximum_wage: 5800)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software de desenvolvimento de software',
                                            vacancy_description: 'O profissional ira trabalhar com varios projetos',
                                            level: :manager,
                                            minimum_wage: 3700,
                                            maximum_wage: 4200)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path

      fill_in 'Busca por', with: 'desen'
      find("[value='full']").set(true)
      fill_in 'Valor minimo', with: 2800

      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
    end

    scenario 'no results' do
      profile = create(:profile, :with_photo)

      first_vacancy = create(:job_vacancy, title: 'Desenvolvedor Ruby',
                                           vacancy_description: 'O profissional ira trabalhar com ruby',
                                           level: :junior,
                                           minimum_wage: 2500,
                                           maximum_wage: 2800)

      second_vacancy = create(:job_vacancy, title: 'Desenvolvedor Java',
                                            vacancy_description: 'O profissional ira trabalhar com java e orientação a objeto',
                                            level: :full,
                                            minimum_wage: 2800,
                                            maximum_wage: 3200)

      third_vacancy = create(:job_vacancy, title: 'Analista Fullstack',
                                           vacancy_description: 'O profissional ira trabalhar varias linguagens',
                                           level: :specialist,
                                           minimum_wage: 5000,
                                           maximum_wage: 5800)

      fourth_vacancy = create(:job_vacancy, title: 'Gerente de projeto de desenvolvimento de software de desenvolvimento de software',
                                            vacancy_description: 'O profissional ira trabalhar com varios projetos',
                                            level: :manager,
                                            minimum_wage: 3700,
                                            maximum_wage: 4200)

      login_as(profile.candidate, scope: :candidate)

      visit job_vacancies_path

      fill_in 'Busca por', with: 'Rails'
      find("[value='senior']").set(true)
      fill_in 'Valor minimo', with: 3500

      click_on 'Pesquisar'

      expect(page).not_to have_content(first_vacancy.heading)
      expect(page).not_to have_content(second_vacancy.heading)
      expect(page).not_to have_content(third_vacancy.heading)
      expect(page).not_to have_content(fourth_vacancy.heading)
      expect(page).to have_content('Não existem vagas abertas no momento')
    end
  end
end
