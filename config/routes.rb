Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope "(:locale)", locale: /en|vi/ do 
    get "static_pages/home"
    get "static_pages/help"
    get "static_pages/about"
    root "static_pages#home"
  end 
end
