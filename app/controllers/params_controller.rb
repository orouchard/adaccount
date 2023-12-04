class ParamsController < ApplicationController
  before_action :set_param, only: %i[ show edit update destroy ]

  # GET /params or /params.json
  def index
    @params = Param.all
  end

  # GET /params/1 or /params/1.json
  def show
  end

  # GET /params/new
  def new
    @param = Param.new
  end

  # GET /params/1/edit
  def edit
  end

  # POST /params or /params.json
  def create
    @param = Param.new(param_params)

    respond_to do |format|
      if @param.save
        format.html { redirect_to params_url, notice: "Param was successfully created." }
        format.json { render :show, status: :created, location: @param }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @param.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /params/1 or /params/1.json
  def update
    respond_to do |format|
      if @param.update(param_params)
        format.html { redirect_to param_url(@param), notice: "Param was successfully updated." }
        format.json { render :show, status: :ok, location: @param }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @param.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /params/1 or /params/1.json
  def destroy
    @param.destroy!

    respond_to do |format|
      format.html { redirect_to params_url, notice: "Param was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_param
      @param = Param.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def param_params
      params.require(:param).permit(:group, :value, :label, :active)
    end
end
