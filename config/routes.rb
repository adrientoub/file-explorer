Rails.application.routes.draw do
  get '/', to: 'index#index'
  get '/:path', to: 'index#path', constraints: { path: /.+/ }
end
