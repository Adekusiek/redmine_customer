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

	post 'company_codes' => 'company_codes#create', as: "company_codes"
	delete 'company_codes/:id' => 'company_codes#destroy', as: "company_code"
end
