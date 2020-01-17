class Api::V1::ApiController < ApplicationController
  private
    def check_purchase_channel
      pcArray = ['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store']

      pcArray.each do |pc|
        if pc == params[:purchase_channel]
          return true
        end
      end
      return false
    end

    def check_delivery_service
      dsArray = ['EUROSENDER', 'SEDEX', 'FEDEX', 'PAC', 'frSENDER', 'deSENDER', 'itSENDER']

      dsArray.each do |ds|
        if ds == params[:delivery_service]
          return true
        end
      end
      return false
    end

    def check_status
      statusArray = ['ready', 'production', 'closing', 'sent']

      statusArray.each do |s|
        if s == params[:status]
          return true
        end
      end
      return false
    end

    def renderJSON(status, msg, httpStatus, data = [])
      render json: {status: status, menssage: msg, data: data}, status: httpStatus
    end
end
