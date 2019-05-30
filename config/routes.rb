Rails.application.routes.draw do
  get '/', to: 'index#index'
  get '/:path', to: 'index#path', constraints: { path: /.+/ }
  put '/:path', to: 'index#rename', constraints: { path: /.+/ }
  delete '/:path', to: 'index#delete', constraints: { path: /.+/ }
end
