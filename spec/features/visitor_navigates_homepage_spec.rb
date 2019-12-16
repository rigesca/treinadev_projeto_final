require 'rails_helper'

feature 'Visitor navigates from homepage' do
    scenario 'and saw a homepage' do
        visit root_path

        expect(page).to have_content("Venha conhecer nossas vagas !")
    end

    context 'visitor is a headhunter ' do
        scenario 'and click in headhunter create page' do
            visit root_path
    
            click_on 'Cadastrar-se como headhunter'
    
            expect(current_path).to eq(new_headhunter_registration_path)
        end
    
        scenario 'and click in headhunter access page' do
            visit root_path
    
            click_on 'Entrar como headhunter'
    
            expect(current_path).to eq(new_headhunter_session_path)
        end
    end
    

    context 'visitor is a candidate ' do
        xscenario 'and click in candidate create page' do
            visit root_path
    
            click_on 'Cadastrar-se como headhunter'
    
            expect(current_path).to eq(new_headhunter_registration_path)
        end
    
        xscenario 'and click in candidate access page' do
            visit root_path
    
            click_on 'Cadastrar-se como headhunter'
    
            expect(current_path).to eq(new_headhunter_sessition_path)
        end
    end


end