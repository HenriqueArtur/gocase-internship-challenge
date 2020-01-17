class Api::V1::OrdersController < Api::V1::ApiController
  def create
    if validate_all
      order = Order.new(reference:        get_country << sprintf('%06i', Order.maximum(:id) == nil ? 1 : Order.maximum(:id).next),
                        purchase_channel: params[:purchase_channel],
                        client_name:      params[:client_name],
                        address:          params[:address],
                        delivery_service: params[:delivery_service],
                        total_value:      params[:total_value],
                        line_items:       params[:line_items],
                        status:           'ready')
      order.save ? renderJSON('SUCCESS', 'Order saved', :created, order) : renderJSON('ERROR', 'Order not saved', :unprocessable_entity)
    else
      renderJSON('ERROR', 'Invalid params', :not_found)
    end
  end

  def get_status
    if params[:reference].blank? && params[:client_name].blank?
      renderJSON('ERROR', 'No params passed', :unprocessable_entity)
    else
      orders = Order.where(reference: params[:reference]).order('created_at DESC').or(Order.where(client_name: params[:client_name]).order('created_at DESC'))
      orders == [] ? renderJSON('SUCCESS', 'No results finded', :not_found, orders) : renderJSON('SUCCESS', "#{orders.length} results finded", :ok, orders)
    end
  end

  def list_by
    if check_purchase_channel && check_status
      orders = Order.where("purchase_channel = ? AND status = ?", params[:purchase_channel], params[:status])
      orders == [] ? renderJSON('SUCCESS', 'No results finded', :not_found, orders) : renderJSON('SUCCESS', "#{orders.length} results finded", :ok, orders)
    else
      renderJSON('ERROR', 'Invalid params', :unprocessable_entity)
    end
  end

  private
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