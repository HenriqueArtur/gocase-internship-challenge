require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "Create" do
    context "Success" do
      it 'witch all params' do
        order_attributes = attributes_for(:order)
        post '/api/v1/orders', params: order_attributes
        expect(response).to have_http_status(201)
      end
    end

    context "Erro" do
      it 'Puchase Channel invalid' do
        order_attributes = attributes_for(:order, purchase_channel: 'Site JP')
        post '/api/v1/orders', params: order_attributes
        expect(response).to have_http_status(404)
      end

      it 'Delivery Service invalid' do
        order_attributes = attributes_for(:order, delivery_service: 'TNT')
        post '/api/v1/orders', params: order_attributes
        expect(response).to have_http_status(404)
      end

      it 'Client Name Blanc' do
        order_attributes = attributes_for(:order, client_name: ' ')
        post '/api/v1/orders', params: order_attributes
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "Get status" do
    context "Success" do
      it 'with Both params' do
        order = create(:order)
        get '/api/v1/orders/get_status', params: {reference: order.reference, client_name: order.client_name}
        expect(response).to have_http_status(200)
      end
      
      it 'with Reference param' do
        order = create(:order)
        get '/api/v1/orders/get_status', params: {reference: order.reference}
        expect(response).to have_http_status(200)
      end
      
      it 'with Cliente Name param' do
        order = create(:order)
        get '/api/v1/orders/get_status', params: {client_name: order.client_name}
        expect(response).to have_http_status(200)
      end
    end

    context "ERROR" do
      it 'Not finded' do
        get '/api/v1/orders/get_status', params: {reference: 'IT999999'}
        expect(response).to have_http_status(404)
      end
      it 'Blanc params' do
        get '/api/v1/orders/get_status'
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "List" do
    context "Success" do
      it 'with Both params' do
        order = create(:order)
        get '/api/v1/orders/list_by', params: {purchase_channel: order.purchase_channel, status: order.status}
        expect(response).to have_http_status(200)
      end
    end

    context "ERROR" do
      it 'with only purchase_channel param' do
        order = create(:order)
        get '/api/v1/orders/list_by', params: {purchase_channel: order.purchase_channel}
        expect(response).to have_http_status(422)
      end
      
      it 'with only status param' do
        order = create(:order)
        get '/api/v1/orders/list_by', params: {status: order.status}
        expect(response).to have_http_status(422)
      end

      it 'Not finded' do
        get '/api/v1/orders/list_by', params: {purchase_channel: 'Site IT', status: 'sent'}
        expect(response).to have_http_status(404)
      end
      it 'Blanc params - status code 422' do
        get '/api/v1/orders/list_by'
        expect(response).to have_http_status(422)
      end
    end
  end
end
