ArpSpreadsheetGenerator::Application.routes.draw do

  root 'spreadsheets#index'
  resources :spreadsheets, :arps, :mass_lines

end
