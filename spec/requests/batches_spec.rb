require 'rails_helper'

RSpec.describe "Batches", type: :request do
  describe "Create" do
    context "Success" do
      it 'witch all params' do
        pcSample = ['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store'].sample
        create_list(:order, 10, purchase_channel: pcSample)
        post '/api/v1/batches', params: { purchase_channel: pcSample }
        expect(response).to have_http_status(201)
      end
    end

    context "ERROR" do
      it 'purchase_channel invalid' do
        post '/api/v1/batches', params: { purchase_channel: 'Store Benfica' }
        expect(response).to have_http_status(404)
      end

      it 'No order to add' do
        post '/api/v1/batches', params: { purchase_channel: 'Site IT' }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "Closing" do
    context "was" do
      it 'Success' do
        pcSample = ['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store'].sample
        batch = create(:batch, purchase_channel: pcSample)
        create_list(:order, 5, {purchase_channel: pcSample, status: 'production', batch: batch})
        post '/api/v1/batches/mark_as_closing', params: { reference: batch.reference }
        expect(response).to have_http_status(200)
      end
    end

    context 'Erro' do
      it 'Not finded' do
        post '/api/v1/batches/mark_as_closing', params: { reference: '201801-54' }
        expect(response).to have_http_status(404)
      end

      it 'Orders not in production' do
        pcSample = ['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store'].sample
        batch = create(:batch, purchase_channel: pcSample)
        create_list(:order, 5, {purchase_channel: pcSample, status: 'closing', batch: batch})
        post '/api/v1/batches/mark_as_closing', params: { reference: batch.reference }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "Send" do
    context "was" do
      it 'Success' do
        pcSample = ['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store'].sample
        dsSample = ['EUROSENDER', 'SEDEX', 'FEDEX', 'PAC', 'frSENDER', 'deSENDER', 'itSENDER'].sample
        batch = create(:batch, purchase_channel: pcSample)
        create_list(:order, 5, {purchase_channel: pcSample, status: 'closing', delivery_service: dsSample, batch: batch})
        post '/api/v1/batches/mark_as_sent', params: { reference: batch.reference, delivery_service: dsSample }
        expect(response).to have_http_status(200)
      end
    end

    context 'Erro' do
      it 'Not reference finded' do
        post '/api/v1/batches/mark_as_sent', params: { reference: '201801-54' }
        expect(response).to have_http_status(404)
      end

      it 'Orders not closing' do
        pcSample = ['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store'].sample
        dsSample = ['EUROSENDER', 'SEDEX', 'FEDEX', 'PAC', 'frSENDER', 'deSENDER', 'itSENDER'].sample
        batch = create(:batch, purchase_channel: pcSample)
        create_list(:order, 5, {purchase_channel: pcSample, status: 'closing', batch: batch})
        post '/api/v1/batches/mark_as_sent', params: { reference: batch.reference, delivery_service: 'TNT' }
        expect(response).to have_http_status(404)
      end
    end
  end
end
