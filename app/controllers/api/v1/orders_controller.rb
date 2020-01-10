class Api::V1::OrdersController < Api::V1::ApiController
  # APAGAR
  def index
    orders = Order.all
    render json: orders
  end

  def create
    if check_delivery_service && check_reference_lenght && check_purchase_channel
      if exit? == false
        order = Order.new(reference: params[:reference], purchase_channel: params[:purchase_channel], client_name: params[:client_name],
                          address: params[:address], delivery_service: params[:delivery_service], total_value: params[:total_value],
                          line_items: params[:line_items], status: 'ready')
        
        if order.save
          render json: {status: 'SUCCESS', menssage:'Loaded Order', data:order}, status: :ok
        else
          render json: {status: 'ERROR', menssage:'Order not saved'}, status: :unprocessable_entity
        end
      else
        render json: {status: 'ERROR', menssage:'Reference already exists'}, status: :unprocessable_entity
      end
    else
      render json: {status: 'ERROR', menssage:'Invalid params'}, status: :unprocessable_entity
    end
  end

  def get_by_reference_or_name
    orders = Order.where(reference: params[:reference]).order('created_at DESC').or(Order.where(client_name: params[:client_name]).order('created_at DESC'))
    if orders == []
      render json: {status: 'SUCCESS', menssage:'No orders finded', data:orders}, status: :ok
    else
      render json: {status: 'SUCCESS', menssage:'Results retuned', data:orders}, status: :ok
    end
  end

  def list_by
    if check_purchase_channel && check_status
      orders = Order.where("purchase_channel = ? AND status = ?", params[:purchase_channel], params[:status])
      if orders == []
        render json: {status: 'SUCCESS', menssage:'No orders finded', data:orders}, status: :ok
      else
        render json: {status: 'SUCCESS', menssage:'Results retuned', data:orders}, status: :ok
      end
    else
      render json: {status: 'ERROR', menssage:'Invalid params'}, status: :unprocessable_entity
    end
  end

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