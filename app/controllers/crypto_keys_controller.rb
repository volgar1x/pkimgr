class CryptoKeysController < ApplicationController
  before_action :set_owner
  before_action :set_crypto_key, except: [:new, :create]

  def new
    @crypto_key = CryptoKey.new
  end

  def create
    case params[:crypto_key][:action]
    when "generate" then generate
    when "import" then import
    end
  end

  def generate
    crypto_key_params = params.require(:crypto_key).permit(:algorithm, :key_size, :curve_name, :name, :owner_password)
    @crypto_key = CryptoKey.new(crypto_key_params)
    @crypto_key.owner = @owner

    if @crypto_key.valid? :generate
      @crypto_key.generate!
      @crypto_key.save!
      redirect_to @owner, notice: "A new cryptographic key has been generated."
    else
      render :new
    end
  end

  def import
    crypto_key_params = params.require(:crypto_key).permit(:compute_public_pem, :name, :owner_password)
    @crypto_key = CryptoKey.new(crypto_key_params)
    @crypto_key.owner = @owner

    if @crypto_key.valid? :import
      if @crypto_key.compute_public_pem == "1"
        private_key = OpenSSL::PKey.read(params[:crypto_key][:private_pem].read, @crypto_key.owner_password)
        @crypto_key.set_private_key private_key, @crypto_key.owner_password
      else
        @crypto_key.private_pem = params[:crypto_key][:private_pem].read
        @crypto_key.public_pem = params[:crypto_key][:public_pem].read
      end
      @crypto_key.save!
      redirect_to @owner, notice: "A new cryptographic key has been imported."
    else
      console
      render :new
    end
  end

  def start_export
  end

  def export
    unless @crypto_key.owner.authenticate(params[:crypto_key][:owner_password])
      @crypto_key.owner.errors.add(:owner_password, "is invalid")
      return render :start_export
    end

    data = case params[:crypto_key][:export_type]
    when "private" then @crypto_key.private_pem
    when "public" then @crypto_key.public_pem
    end

    filename = "#{@crypto_key.name} #{@crypto_key.owner.name} #{params[:crypto_key][:export_type]}"

    send_data data, type: "application/x-pem-file", filename: "#{filename}.pem"
  end

  private
    def set_owner
      @owner = case request.path.split("/")[1]
      when "authorities" then Authority.find(params[:authority_id]) if params[:authority_id]
      when "profile" then current_user
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_crypto_key
      @crypto_key = CryptoKey.find(params[:id])
    end
end
