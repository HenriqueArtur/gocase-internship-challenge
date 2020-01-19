class Api::V1::OrdersController < Api::V1::ApiController
  def create
    if validate_all
      order = Order.new(order_params)
      order.save ? render_json('SUCCESS', 'Order saved', :created, order) : render_json('ERROR', 'Order not saved', :unprocessable_entity)
    else
      render_json('ERROR', 'Invalid params', :not_found)
    end
  end

  def get_status
    if params[:reference].blank? && params[:client_name].blank?
      render_json('ERROR', 'No params passed', :unprocessable_entity)
    else
      orders = Order.where(reference: params[:reference]).order('created_at DESC').or(Order.where(client_name: params[:client_name]).order('created_at DESC'))
      orders.any? ? render_json('SUCCESS', "#{orders.length} results finded", :ok, orders) : render_json('SUCCESS', 'No results finded', :not_found, orders)
    end
  end

  def list_by
    if check_purchase_channel && check_status
      orders = Order.where(purchase_channel: params[:purchase_channel], status: params[:status])
      orders.any? ? render_json('SUCCESS', "#{orders.length} results finded", :ok, orders) : render_json('SUCCESS', 'No results finded', :not_found, orders)
    else
      render_json('ERROR', 'Invalid params', :unprocessable_entity)
    end
  end

  private
    def order_params
      params.permit(:purchase_channel, :client_name, :address, :delivery_service, :total_value, :line_items).merge(status: 'ready', reference: get_country << sprintf('%06i', Order.maximum(:id) == nil ? 1 : Order.maximum(:id).next))
    end

    def validate_all
      if check_delivery_service && check_purchase_channel
        return true
      end
      return false
    end

    def get_country
      countryArray = ['Site BR', 'Site EN', 'Site DE', 'Site FR', 'Site IT', 'Iguatemi Store']

      case params[:purchase_channel]
      when 'Site BR'
      when 'Iguatemi Store'
        return 'BR'
      when 'Site EN'
        return 'EN'
      when 'Site DE'
        return 'DE'
      when 'Site FR'
        return 'FR'
      when 'Site IT'
        return 'IT'
      end
    end
end