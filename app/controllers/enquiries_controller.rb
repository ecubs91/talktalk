class EnquiriesController < ApplicationController
  before_action :set_enquiry, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  # GET /enquiries
  # GET /enquiries.json


  def index
    @enquiries = Enquiry.all.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /enquiries/1
  # GET /enquiries/1.json
  def show
  end

  # GET /enquiries/new
  def new
    @enquiry = Enquiry.new
  end

  # GET /enquiries/1/edit
  def edit
  end

  # POST /enquiries
  # POST /enquiries.json
  def create
    @enquiry = Enquiry.new(enquiry_params)
    @enquiry.user_id = current_user.id
    
    @tutor_profile = User.find(params[:tutor_profile])
    
    respond_to do |format|
      if @enquiry.save
        @enquiry.send_message(@a)
        format.html { redirect_to @enquiry, notice: 'Enquiry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @enquiry }
      else
        format.html { render action: 'new' }
        format.json { render json: @enquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enquiries/1
  # PATCH/PUT /enquiries/1.json
  def update
    respond_to do |format|
      if @enquiry.update(enquiry_params)
        format.html { redirect_to @enquiry, notice: 'Enquiry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @enquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enquiries/1
  # DELETE /enquiries/1.json
  def destroy
    @enquiry.destroy
    respond_to do |format|
      format.html { redirect_to enquiries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enquiry
      @enquiry = Enquiry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enquiry_params
      params.require(:enquiry).permit(:subject, :level, :location, :duration, :start_date, :tuition_fee, :note, :tutor_availablity, :tutorial_request)
    end

    def check_user
      if current_user != @enquiry.user
        redirect_to root_url, alert: "Sorry this profile belongs to someone else"
      end
    end
end
