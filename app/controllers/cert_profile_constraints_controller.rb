class CertProfileConstraintsController < ApplicationController
  before_action :set_cert_profile_constraint, only: [:show, :edit, :update, :destroy]

  # GET /cert_profile_constraints
  # GET /cert_profile_constraints.json
  def index
    @cert_profile_constraints = CertProfileConstraint.all
  end

  # GET /cert_profile_constraints/1
  # GET /cert_profile_constraints/1.json
  def show
  end

  # GET /cert_profile_constraints/new
  def new
    @cert_profile_constraint = CertProfileConstraint.new
  end

  # GET /cert_profile_constraints/1/edit
  def edit
  end

  # POST /cert_profile_constraints
  # POST /cert_profile_constraints.json
  def create
    @cert_profile_constraint = CertProfileConstraint.new(cert_profile_constraint_params)

    respond_to do |format|
      if @cert_profile_constraint.save
        format.html { redirect_to @cert_profile_constraint, notice: 'Cert profile constraint was successfully created.' }
        format.json { render :show, status: :created, location: @cert_profile_constraint }
      else
        format.html { render :new }
        format.json { render json: @cert_profile_constraint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cert_profile_constraints/1
  # PATCH/PUT /cert_profile_constraints/1.json
  def update
    respond_to do |format|
      if @cert_profile_constraint.update(cert_profile_constraint_params)
        format.html { redirect_to @cert_profile_constraint, notice: 'Cert profile constraint was successfully updated.' }
        format.json { render :show, status: :ok, location: @cert_profile_constraint }
      else
        format.html { render :edit }
        format.json { render json: @cert_profile_constraint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cert_profile_constraints/1
  # DELETE /cert_profile_constraints/1.json
  def destroy
    @cert_profile_constraint.destroy
    respond_to do |format|
      format.html { redirect_to cert_profile_constraints_url, notice: 'Cert profile constraint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cert_profile_constraint
      @cert_profile_constraint = CertProfileConstraint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cert_profile_constraint_params
      params.require(:cert_profile_constraint).permit(:profile_id, :type, :value)
    end
end
