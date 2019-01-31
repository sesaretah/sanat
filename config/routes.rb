Rails.application.routes.draw do
  resources :access_controls
  resources :companies
  resources :faqs
  resources :blogs
  devise_for :users, :controllers => {:registrations => "registrations", sessions: "sessions"}
  resources :uploads
  resources :advertisements

  root "home#index"


  get '/advertisements/check/:id', to: "advertisements#check"
  get '/advertisements/change_rank/:id', to: "advertisements#change_rank"

  get '/blogs/check/:id', to: "blogs#check"
  get '/blogs/change_rank/:id', to: "blogs#change_rank"
  get '/settings', to: "settings#index"
  get '/settings/section', to: "settings#sections"

  post '/categories', to: "categories#create"
  get '/categories/:id/destroy', to: "categories#destroy"
  get '/categories/change_rank/:id', to: "categories#change_rank"

  post '/roles', to: "roles#create"
  get '/roles/:id/destroy', to: "roles#destroy"
  get '/roles/access/:id', to: "roles#access"
  get '/roles/change_current_role', to: "roles#change_current_role"

  post '/provinces', to: "provinces#create"
  get '/provinces/:id/destroy', to: "provinces#destroy"

  post '/assignments', to: "assignments#create"
  get '/assignments/:id/destroy', to: "assignments#destroy"
  get '/advertisements/change_status/:id', to: "advertisements#change_status"
  get '/advertisements/change_size/:id', to: "advertisements#change_size"

  get '/uploads/remoted/:id', to: "uploads#remoted"

  get '/api/advertisements', to: "api#advertisements"
  get '/api/advertisement/:id', to: "api#advertisement"
  get '/api/login', to: "api#login"
  get '/api/profile', to: "api#profile"
  get '/api/my_advertisements', to: "api#my_advertisements"
  get '/api/delete_advertisement/:id', to: "api#delete_advertisement"
  get '/api/delete_photo/:id', to: "api#delete_photo"
  get '/api/make_pin/:id', to: "api#make_pin"
  get '/api/pinned/:id', to: "api#pinned"
  get '/api/unpin/:id', to: "api#unpin"
  get '/api/like/:id', to: "api#like"
  get '/api/dislike/:id', to: "api#dislike"
  get '/api/liked/:id', to: "api#liked"
  get '/api/messages/:id', to: "api#messages"
  get '/api/grouped_messages', to: "api#grouped_messages"
  get '/api/admin_grouped_messages', to: "api#admin_grouped_messages"
  get '/api/rooms/:id', to: "api#rooms"
  get '/api/seen/:id', to: "api#seen"
  get '/api/user_advert_room/:id', to: "api#user_advert_room"
  get '/api/all_unseens', to: "api#all_unseens"
  get '/api/my_pins', to: "api#my_pins"
  get '/api/update_token', to: "api#update_token"
  get '/api/provinces', to: "api#provinces"
  get '/api/categories', to: "api#categories"
  get '/api/category/:id', to: "api#category"



  post '/api/sign_up', to: "api#sign_up"
  post '/api/make_advertisement', to: "api#make_advertisement"
  post '/api/upload', to: "api#upload"
  post '/api/edit_advertisement', to: "api#edit_advertisement"
  post '/api/new_message/:id', to: "api#new_message"

end
