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
        render json: {status: 'SUCCESS', menssage:'Loaded Order', batch:batch, group_of_orders: batch.orders}, status: :ok
      else
        render json: {status: 'ERROR', menssage:'Batch not saved'}, status: :unprocessable_entity
      end
    else
      render json: {status: 'ERROR', menssage:'Invalid Puchase Channel'}, status: :unprocessable_entity
    end
  end

  def mark_as_closing
    if Batch.exists?(['reference LIKE ?', params[:reference]])
      orders = Batch.where(reference: params[:reference]).take.orders
      orders.each do |order|
        order.update_attribute(:status, 'closing')
      end
      render json: {status: 'SUCCESS', menssage:'Orders Updated'}, status: :ok
    else
      render json: {status: 'ERROR', menssage:'Batch dont exists'}, status: :unprocessable_entity
    end
  end

  def mark_as_sent
    if Batch.exists?(['reference = ? AND purchase_channel = ?', params[:reference], params[:purchase_channel]])
      if order_is_closing?
        orders = Batch.where(reference: params[:reference]).take.orders
        orders.each do |order|
          order.update_attribute(:status, 'sent')
        end
        render json: {status: 'SUCCESS', menssage:'Orders Updated', data: orders}, status: :ok
      else
        render json: {status: 'ERROR', menssage:'Orders Batch dont closing'}, status: :unprocessable_entity
      end
    else
      render json: {status: 'ERROR', menssage:'Batch dont exists'}, status: :unprocessable_entity
    end
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

end