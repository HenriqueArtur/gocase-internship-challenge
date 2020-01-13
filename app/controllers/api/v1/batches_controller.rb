class Api::V1::BatchesController < Api::V1::ApiController
  def index
    batches = Batch.all
    render json: batches
  end
end