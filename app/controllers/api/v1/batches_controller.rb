class Api::V1::BatchesController < Api::V1::ApiController
  def create
    orders = Order.where("purchase_channel = ? AND status = ?", params[:purchase_channel], 'ready')

    if check_purchase_channel && orders != []
      batch = Batch.new(reference:        Date.today.year.to_s << sprintf('%02i', Date.today.month) << '-' << sprintf('%02i', Batch.maximum(:id) == nil ? 1 : Batch.maximum(:id).next),
                        purchase_channel: params[:purchase_channel])
      orders.each do |order|
        order.batch = batch
        order.update_attribute(:status, 'production')
      end

      if batch.save
        render json: {status: 'SUCCESS', menssage:'Loaded Order', data:batch, orders_data: orders}, status: :created
      else
        renderJSON('ERROR', 'Batch not saved', :unprocessable_entity)
      end
    else
      !check_purchase_channel ? renderJSON('ERROR', 'Invalid Puchase Channel', :not_found) : renderJSON('ERROR', 'No Orders to create a Batch', :unprocessable_entity)
    end
  end

  def mark_as_closing
    if Batch.exists?(['reference LIKE ?', params[:reference]])
      orders = Batch.where(reference: params[:reference]).take.orders.where(status: 'production')
      orders != [] ? order_status_to('closing', orders) : renderJSON('ERROR', 'orders not in production', :unprocessable_entity)
    else
      renderJSON('ERROR', 'batch dont finded', :not_found)
    end
  end

  def mark_as_sent
    if Batch.exists?(['reference = ?', params[:reference]])
      orders = Batch.where(reference: params[:reference]).take.orders.where("delivery_service = ? AND status = 'closing'", params[:delivery_service])
      orders != [] ? order_status_to('sent', orders) : renderJSON('ERROR', "Orders with delivery_service #{params[:delivery_service]} no finded", :not_found, orders)
    else
      renderJSON('ERROR', "Batch witch reference #{params[:reference]} no finded", :not_found)
    end
  end

  private
    def order_status_to(status, orders)
      orders.each do |order|
        order.update_attribute(:status, status)
      end
      renderJSON('SUCCESS', "#{orders.length} orders updated to '#{status}'", :ok, orders)
    end
end