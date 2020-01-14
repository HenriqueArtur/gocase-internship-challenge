class Api::V1::ApiController < ApplicationController
  private
    def check_reference_lenght
      params[:reference].to_s.length === 8 ? true : false
    end

    def check_purchase_channel
      pcArray = ['Site BR', 'Site EU', 'Site US']

      pcArray.each do |pc|
        if pc == params[:purchase_channel]
          return true
        end
      end
      return false
    end

    def check_delivery_service
      dsArray = ['EUROSENDER', 'SEDEX', 'FEDEX']

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

    def exit?
      orders = Order.all

      orders.each do |order|
        if order.reference == params[:reference]
          return true
        end
      end
      return false
    end
end
