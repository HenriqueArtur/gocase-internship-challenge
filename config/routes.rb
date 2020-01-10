Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :orders do
        collection do
          get 'list_by'
          get 'get_by_reference'
        end
      end
    end
  end
end
