class Api::V1::BatchesController < Api::V1::ApiController
  def index
    batches = Batch.all
    render json: batches
  end

  def create
    orders = Order.where("purchase_channel = ? AND status = ?", params[:purchase_channel], 'ready')

    if check_purchase_channel && orders != []
      batch = Batch.new(reference: Date.today.year.to_s << sprintf('%02i', Date.today.month) << '-' << sprintf('%02i', Batch.maximum(:id).next),
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
      !check_purchase_channel ? renderJSON('ERROR', 'Invalid Puchase Channel', :unprocessable_entity) : renderJSON('ERROR', 'No Orders to create a Batch', :unprocessable_entity)
    end
  end

  def mark_as_closing
    Batch.exists?(['reference LIKE ?', params[:reference]]) ? order_status_to_closing : renderJSON('ERROR', 'batch dont finded', :ok)
  end

  def mark_as_sent
    # if Batch.exists?(['reference = ? AND delivery_service = ?', params[:reference], params[:delivery_service]])
    #   order_is_closing? ? order_status_to_sent : renderJSON('ERROR', 'Orders in Batch dont closing', :ok)
    #   # if order_is_closing?
    #   #   orders = Batch.where(reference: params[:reference]).take.orders
    #   #   orders.each do |order|
    #   #     order.update_attribute(:status, 'sent')
    #   #   end
    #   #   render json: {status: 'SUCCESS', menssage:'Orders Updated', data: orders}, status: :ok
    #   # else
    #   #   render json: {status: 'ERROR', menssage:'Orders in Batch dont closing'}, status: :unprocessable_entity
    #   # end
    # else
    #   renderJSON('ERROR', 'Batch dont finded', :unprocessable_entity) 
    # end
    #batch = Batch.includes(:orders)
    #orders = Order.includes(:batch).where('batch.reference = ?', params[:reference]).references(:batch)
    orders = Batch.where(reference: params[:reference]).take.orders.where('delivery_service = ?', params[:delivery_service])
    renderJSON(' ', ' ', :ok, orders)
  end

  private
    def order_is_closing?
      orders = Batch.where(reference: params[:reference]).take.orders
      orders.each do |order|
        if order.status != 'closing'
          return false
        end
        return true
      end
    end

    def order_status_to_closing
      orders = Batch.where(reference: params[:reference]).take.orders
      orders.each do |order|
        order.update_attribute(:status, 'closing')
      end
      renderJSON('SUCCESS', "#{orders.length} orders updated to 'closing'", :ok, orders)
    end

    def order_status_to_sent
      orders = Batch.where([reference: params[:reference]]).take.orders.where([delivery_service: params[:delivery_service]]).take
      #orders = Batch.where(['reference = ? AND delivery_service = ?', params[:reference], params[:delivery_service]]).take.orders
      orders.each do |order|
        order.update_attribute(:status, 'closing')
      end
      renderJSON('SUCCESS', "#{orders.length} orders updated to 'sent'", :ok, orders)
    end
end