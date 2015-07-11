class TutorshipsController < ApplicationController
  before_action :set_tutorship, only: [:show, :edit, :update, :destroy]
  

  def tutors
    @tutorships = Tutorship.all
  end
  
  def students
    @tutorships = Tutorship.all
  end
  
  # GET /tutorships
  # GET /tutorships.json
  def index
    @tutorships = Tutorship.all
  end

  # GET /tutorships/1
  # GET /tutorships/1.json
  def show
  end

  # GET /tutorships/new
  def new
    @tutorship = Tutorship.new
  end

  # GET /tutorships/1/edit
  def edit
    
    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (@tutorship.tuition_fee * 100).floor,
        :currency => "usd",
        :card => token
        )
      flash[:notice] = "Thanks for booking!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end
    
  end

  
  # POST /tutorships
  # POST /tutorships.json
  def create
    @tutorship = Tutorship.new(tutorship_params)
    
    @tutorship.user_id = current_user.id
    @tutor_profile = User.find(params[:tutor_profile]) #tutor__profile id in the tutorship table equals the tutor__profile_id of the tutor_profile student is on 
    respond_to do |format|
      if @tutorship.save
        format.html { redirect_to @tutorship, notice: 'Tutorship was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tutorship }
      else
        format.html { render action: 'new' }
        format.json { render json: @tutorship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tutorships/1
  # PATCH/PUT /tutorships/1.json
  def update
    respond_to do |format|
      if @tutorship.update(params[:tutor_profile])
        format.html { redirect_to @tutorship, notice: 'Tutorship was successfully accepted.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tutorship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutorships/1
  # DELETE /tutorships/1.json
  def destroy
    @tutorship.destroy
    respond_to do |format|
      format.html { redirect_to tutorships_url }
      format.json { head :no_content }
    end
  end
  
    def invite_to_tutorship
    @tutor_profile = User.find(params[:tutor__profile_id] )
    @user = current_user
    @enquiry = current_user.enquiries.last
    @tutor_profile.pending_invites_to_be_a_tutor.create(subject: @enquiry.subject, message: @enquiry.note,  user_id: current_user.id, status: :invited)
 
    redirect_to :tutor_profiles
  end

  def accept_tutorship
    @tutorship = Tutorship.find(params[:id])
    accepted_tutorship = @tutorship.update(accepted: true)
    
    redirect_to :tutor_profiles    
  end
  
private
    # Use callbacks to share common setup or constraints between actions.
    def set_tutorship
      @tutorship = Tutorship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tutorship_params
      params.require(:tutorship).permit(:tutor_profile_id, :user_id, :accepted, :created_by_student, :starting_date, :hourly_rate, :hours_a_week, :weeks, :tuition_fee)
    end
end
