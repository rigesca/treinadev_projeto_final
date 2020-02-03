# frozen_string_literal: true

require 'rails_helper'

feature 'A visitor no-authenticate try to access' do
  scenario 'show proposal option' do
    proposal = create(:proposal)
    visit proposal_path(proposal)

    expect(current_path).to eq(root_path)
  end

  scenario 'index proposal option' do
    proposal = create(:proposal)
    visit proposal_path(proposal)

    expect(current_path).to eq(root_path)
  end
end
