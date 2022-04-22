Rails.application.routes.draw do
  get 'staticpages/home'
  get 'staticpages/help'
  get 'staticpages/about'
  root 'staticpages#home'
end
