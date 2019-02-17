Rails.application.routes.draw do
  resources :items, except: [:new, :create, :show] do
    collection do
      get :stat
      get :fetch_data
      get :get_children_type
      get :annual_report
      get :quarterly_report
    end
  end
  resources :diary_logs, except: [:new, :create, :show]
  mount WeixinRailsMiddleware::Engine, at: "/"
  get 'report' => 'page#report'
end
