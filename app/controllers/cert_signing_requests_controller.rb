class CertSigningRequestsController < ApplicationController
  before_action :set_cert_signing_request, only: [:show, :edit, :update, :destroy]

  # GET /cert_signing_requests
  # GET /cert_signing_requests.json
  def index
    @cert_signing_requests = CertSigningRequest.all
  end

  # GET /cert_signing_requests/1
  # GET /cert_signing_requests/1.json
  def show
  end

  # GET /cert_signing_requests/new
  def new
    @cert_signing_request = CertSigningRequest.new
  end

  # GET /cert_signing_requests/1/edit
  def edit
  end

  # POST /cert_signing_requests
  # POST /cert_signing_requests.json
  def create
    @cert_signing_request = CertSigningRequest.new(cert_signing_request_params)

    respond_to do |format|
      if @cert_signing_request.save
        format.html { redirect_to @cert_signing_request, notice: 'Cert signing request was successfully created.' }
        format.json { render :show, status: :created, location: @cert_signing_request }
      else
        format.html { render :new }
        format.json { render json: @cert_signing_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cert_signing_requests/1
  # PATCH/PUT /cert_signing_requests/1.json
  def update
    respond_to do |format|
      if @cert_signing_request.update(cert_signing_request_params)
        format.html { redirect_to @cert_signing_request, notice: 'Cert signing request was successfully updated.' }
        format.json { render :show, status: :ok, location: @cert_signing_request }
      else
        format.html { render :edit }
        format.json { render json: @cert_signing_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cert_signing_requests/1
  # DELETE /cert_signing_requests/1.json
  def destroy
    @cert_signing_request.destroy
    respond_to do |format|
      format.html { redirect_to cert_signing_requests_url, notice: 'Cert signing request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cert_signing_request
      @cert_signing_request = CertSigningRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cert_signing_request_params
      params.require(:cert_signing_request).permit(:subject_id, :subject_type, :profile_id, :pem)
    end
end
