class Api::V1::OrdersController < Api::V1::ApiController
  # APAGAR
  def index
    orders = Order.all
    render json: orders
  end

  def create
    if check_delivery_service && check_reference && check_purchase_channel
      render json: {resultado: 'deu certo!'}
    else
      render json: {resultado: 'deu errado!'}
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
    def check_reference
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

end