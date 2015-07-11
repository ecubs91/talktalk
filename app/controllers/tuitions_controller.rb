class TuitionsController < ApplicationController
  before_action :set_tuition, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :set_tutor_profile, only: [:payment_detail]

  # GET /tuitions
  # GET /tuitions.json
  
  def mytuition
    if current_user.tutor_profile.present?
      @tuitions =
          Tuition.all.where(user_id: current_user.id).order("created_at DESC") + (Tuition.all.where(tutor_profile_id: current_user.tutor_profile.id).order("created_at DESC") if current_user.tutor_profile.present?)
    else
      @tuitions =
          Tuition.all.where(user_id: current_user.id).order("created_at DESC")
    end
  end
  
  def index
    @tuitions = Tuition.all
  end

  def book_tuition
    @tuition = Tuition.new
    @tutor_profile = TutorProfile.find(params[:tutor_profile_id])
  end

  def payment_detail
    validation_flag = false
    @tuition = current_user.tuitions.new(tuition_params)
    tuition_params.each do |key,value|
      if value.blank?
        validation_flag = true
      end
    end
    if validation_flag
      flash[:error] = "Please fill all the required fields."
      redirect_to :back
    end
    @tuition.tutor_profile_id = @tutor_profile.id
  end

  def perform_transaction
    Stripe.api_key = "sk_test_4Ld3SH8JuQyRKJYNTvAE2EIt"

    stripe_token = Stripe::Token.create(
        :card => {
            :number => payment_details_params[:credit_card_number],
            :exp_month => payment_details_params[:expiration_month],
            :exp_year => payment_details_params[:expiration_year],
            :cvc => payment_details_params[:cvv]
        },
    ) rescue false

    if stripe_token
      @tuition = Tuition.new(tuition_params)
      @tutor_profile = @tuition.tutor_profile
      transaction = Stripe::Charge.create(
          :amount => (@tutor_profile.hourly_rate).to_i*@tuition.hours*100 ,
          :currency => "GBP",
          :card => stripe_token[:id], # obtained from successful token response
      ) rescue false
      if transaction
        @tuition.payment_transaction = transaction[:id]
        @tuition.payment_amount = transaction[:amount]/100
        @tuition.save
flash[:notice] = "Transaction is successful. You have paid £#{'%.2f' % @tuition.payment_amount} to #{@tutor_profile.user.first_name} #{@tutor_profile.user.last_name} for #{@tuition.hours} hours."
        redirect_to tutor_profile_path(@tutor_profile)
      else
        flash[:error] = "Something went wrong and transaction is not performed. Please check your payment details OR contact GuruMe Support."
        redirect_to :back
      end
    else
      flash[:error] = "The Payment Information seems incorrect. Please Verify your payment details."
      redirect_to :back
    end
  end

  # GET /tuitions/1
  # GET /tuitions/1.json
  def show
  end

  # GET /tuitions/new
  def new
    @tuition = Tuition.new
    @tutor_profile = TutorProfile.find(params[:tutor_profile_id])
  end

  # GET /tuitions/1/edit
  def edit
  end

  # POST /tuitions
  # POST /tuitions.json
  def create
    @tuition = Tuition.new(tuition_params)
    @tuition.user_id = current_user.id
    
    @tutor_profile = TutorProfile.find(params[:tutor_profile_id])
    @tuition.tutor_profile_id = @tutor_profile.id

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]
    raise token.inspect

    begin
      charge = Stripe::Charge.create(
        :amount => (@tutor_profile.hourly_rate * 100).floor,
        :currency => "gbp",
        :card => token
        )
      flash[:notice] = "Thanks for booking!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end
    
    respond_to do |format|
      if @tuition.save
        format.html { redirect_to tutor_profile_path@tutor_profile, notice: 'Tuition was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tuition }
      else
        format.html { render action: 'new' }
        format.json { render json: @tuition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tuitions/1
  # PATCH/PUT /tuitions/1.json
  def update
    respond_to do |format|
      if @tuition.update(tuition_params)
        format.html { redirect_to @tuition, notice: 'Tuition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tuition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tuitions/1
  # DELETE /tuitions/1.json
  def destroy
    @tuition.destroy
    respond_to do |format|
      format.html { redirect_to tuitions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tuition
      @tuition = Tuition.find(params[:id]) rescue nil
    end

    def set_tutor_profile
      @tutor_profile = TutorProfile.find(params[:tutor_profile_id])
    end

    def payment_details_params
      params.permit(:credit_card_number,:cvv,:expiration_month,:expiration_year)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tuition_params
      params.require(:tuition).permit(:hours, :city, :note, :user_id, :tutor_profile_id, :payment_transaction, :payment_amount)
    end
end
