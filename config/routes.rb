Rails.application.routes.draw do
  get '/', to: 'index#index'
  post '/', to: 'index#upload_index'
  get '/:path', to: 'index#path', constraints: { path: /.+/ }
  put '/:path', to: 'index#rename', constraints: { path: /.+/ }
  post '/:path', to: 'index#upload', constraints: { path: /.+/ }
  delete '/:path', to: 'index#delete', constraints: { path: /.+/ }
end
