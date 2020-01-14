Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :batches do
        collection do
          post 'mark_as_closing'
          post 'mark_as_sent'
        end
      end
      resources :orders do
        collection do
          get 'list_by'
          get 'get_status'
        end
      end
    end
  end
end
