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

  def get_by_reference
    order = Order.where(reference: params[:reference])
    render json: order
  end

  def list_by
    orders = Order.where(purchase_channel: params[:purchase_channel])
    render json: orders
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