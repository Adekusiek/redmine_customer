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

	post 'category_import/:id' => 'supports#category_import', as: "category_import"
	patch 'refuse_enquete/:id' => 'enquetes#refuse_enquete', as: "refuse_enquete"
	patch 'accept_enquete/:id' => 'enquetes#accept_enquete', as: "accept_enquete"
	patch 'set_reply/:id' => 'enquetes#set_reply', as: "set_reply"
	get 'project/:project_id/enquetes'=> 'enquetes#index'
	get 'project/:project_id/telephone_process/' => 'telephone_process#index', as: "telephone_process"
	get 'project/:project_id/telephone_process/search' => 'telephone_process#search', as: "customer_search"
	patch 'skip_enquete/:id' => 'supports#skip_enquete', as: "skip_enquete"
	patch 'change_auto_close_flag/:id' => 'supports#change_auto_close_flag', as: "change_auto_close_flag"
end
