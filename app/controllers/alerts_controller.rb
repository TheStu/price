class AlertsController < ApplicationController
  authorize_resource

  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alerts }
    end
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
    @alert = Alert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alert }
    end
  end

  # GET /alerts/new
  # GET /alerts/new.json
  def new
    @alert = Alert.new
    @selected = params[:alert_ids]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alert }
    end
  end

  # GET /alerts/1/edit
  def edit
    @alert = Alert.find(params[:id])
  end

  # POST /alerts
  # POST /alerts.json
  def create
    if params[:product_sku].present? && params[:best_price].present?
      build_results(params).each do |result|
        alert = Alert.new(result)
        if alert.save
          @success = true
        else
          @success = false
        end
      end
      if @success == true
        redirect_to root_path, notice: 'Price alerts were successfully created.'
      else
        redirect_to root_path, notice: 'Something went wrong, and one or more of your price alerts was not saved.'
      end
    else
      redirect_to :back, notice: 'Oops, make sure you enter a max price and check the box beside at least one of the results.'
    end
  end

  # PUT /alerts/1
  # PUT /alerts/1.json
  def update
    @alert = Alert.find(params[:id])

    respond_to do |format|
      if @alert.update_attributes(params[:alert])
        format.html { redirect_to user_path(current_user), notice: 'Alert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert = Alert.find(params[:id])
    @alert.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

  private

  def build_results(params)
    results = []
    params['product_skus'].count.times do |i|
      result = {}
      result['product_sku'] = params['product_skus'][i]
      result['merchant_id'] = params['merchant_ids'][i]
      result['product_name'] =  params['product_names'][i]
      result['price'] =  params['best_price']
      result['user_id'] =  current_user.id
      results << result
    end
    return results
  end
end
