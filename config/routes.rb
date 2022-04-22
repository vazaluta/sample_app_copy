Rails.application.routes.draw do
  get 'staticpages/home'
  get 'staticpages/help'
  root 'staticpages#home'
end
