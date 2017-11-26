Rails.application.routes.draw do

  scope '/watson' do
    resources :personalitys_insights, only: [:new, :create]
  end
end
