# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
	resources :issues, only: [:update] do
		patch 'supports/' => 'supports#update'
	end
	resources :projects, only: [:new, :create] do
		get 'supports/new' => 'supports#new'
    post 'supports/' => 'supports#create'

	end
end
