class Api::V1::BatchesController < Api::V1::ApiController
  def create
    orders = Order.where(purchase_channel:  params[:purchase_channel], status: 'ready')

    if check_purchase_channel && orders.any?
      batch = Batch.new(reference:        Date.today.year.to_s << sprintf('%02i', Date.today.month) << '-' << sprintf('%02i', Batch.maximum(:id) == nil ? 1 : Batch.maximum(:id).next),
                        purchase_channel: params[:purchase_channel])
      orders.each do |order|
        order.batch = batch
        order.update_attribute(:status, 'production')
      end

      if batch.save
        render json: {status: 'SUCCESS', menssage:'Loaded Order', data:batch, orders_data: orders}, status: :created
      else
        render_json('ERROR', 'Batch not saved', :unprocessable_entity)
      end
    else
      !check_purchase_channel ? render_json('ERROR', 'Invalid Puchase Channel', :not_found) : render_json('ERROR', 'No Orders to create a Batch', :unprocessable_entity)
    end
  end

  def mark_as_closing
    if Batch.exists?(['reference LIKE ?', params[:reference]])
      orders = Batch.where(reference: params[:reference]).take.orders.where(status: 'production')
      orders.any? ? order_status_to('closing', orders) : render_json('ERROR', 'orders not in production', :unprocessable_entity)
    else
      render_json('ERROR', 'batch dont finded', :not_found)
    end
  end

  def mark_as_sent
    if Batch.exists?(['reference = ?', params[:reference]])
      orders = Batch.where(reference: params[:reference]).take.orders.where(delivery_service: params[:delivery_service], status: 'closing')
      orders.any? ? order_status_to('sent', orders) : render_json('ERROR', "Orders with delivery_service #{params[:delivery_service]} no finded", :not_found, orders)
    else
      render_json('ERROR', "Batch witch reference #{params[:reference]} no finded", :not_found)
    end
  end

  private
    def order_status_to(status, orders)
      orders.each do |order|
        order.update_attribute(:status, status)
      end
      render_json('SUCCESS', "#{orders.length} orders updated to '#{status}'", :ok, orders)
    end
end