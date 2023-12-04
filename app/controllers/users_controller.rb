class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_wizzard, only: %i[ wizzard ]
  
  # GET /users or /users.json
  def index
    @categories = Tag.where(active: true)
  end
  
  def list
    if params[:id] == "all"
      @users = User.includes(:tags, :invoices).where(visible: true).order(:name)
    else
      @tag = Tag.find(params[:id])
      @users = @tag.users.includes(:tags, :invoices).where(visible: true).order(:name)
    end
    @categories = Tag.where(active: true)
  end

  # GET /users/1 or /users/1.json
  def show
    @invoices = @user.invoices.order(:date_issue)
    
    # dates for journal wizard
    @d1 = Param.first_day
    @months_dur = Param.months_dur
    set_months
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end
  
  def wizzard
    unless (@country || @gender) == ""
      @names = User.where(nationality: @country, title: @gender).map(&:name)
      @name = Name.where(country: @country, gender: @gender).where.not(full_name: @names).take
      @user = User.create!(name: @name.full_name, title: @gender, nationality: @country )
      redirect_to @user
    else
      redirect_to users_url, notice: "For a new Wizzard User, please select all the options."
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    def set_wizzard
      @country = params[:country]
      @gender = params[:gender]
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:title, :name, :nationality, tag_ids: [])
    end
end
