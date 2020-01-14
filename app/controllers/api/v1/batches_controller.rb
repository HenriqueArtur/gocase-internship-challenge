class Api::V1::BatchesController < Api::V1::ApiController
  def index
    batches = Batch.all
    render json: batches
  end

  def create
    batch = Batch.new(reference: Date.today.year.to_s << Date.today.month.to_s << '-' << Batch.maximum(:id).next,
                      purchase_channel: params[:purchase_channel])
    orders = Order.where(purchase_channel: params[:purchase_channel])
    orders.each do |order|
      order.update_attributes(:status, 'production')
      order.batch = batch
    end
    render json: {status: 'SUCCESS', menssage:'Loaded Order', data:batch}, status: :ok
  end
end