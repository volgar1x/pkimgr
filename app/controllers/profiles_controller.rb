class ProfilesController < SecureController
  def edit
  end

  def update
    if params[:profile][:action] == "destroy"
      if current_user.authenticate(params[:profile][:password])
        reset_session
        return redirect_to misc_dashboard_path
      else
        current_user.errors.add(:password, "is invalid")
        return render :edit
      end
    end

    profile_params = params.require(:profile).permit(
      :email, :phone, :firstname, :lastname,
      :country, :state, :city, :zip,
    )

    current_user.assign_attributes(profile_params)

    unless current_user.authenticate(params[:profile][:password])
      current_user.errors.add(:password, "is invalid")
      return render :edit
    end

    respond_to do |format|
      if current_user.save
        format.html { redirect_to edit_profile_path, notice: 'Your profile was successfully updated.' }
        format.json { render :show, status: :ok, location: profile_path }
      else
        format.html { render :edit }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def start_import
  end

  def import
    import_params = params.require("profile_import")

    unless current_user.authenticate(import_params["password"])
      current_user.errors.add(:password, "is invalid")
      return render :start_import
    end

    if encrypt_key_file = import_params["encrypt_key_pem"]
      encrypt_key_pem = encrypt_key_file.read
      begin
        encrypt_key = OpenSSL::PKey.read(encrypt_key_pem, import_params["password"])
      rescue OpenSSL::PKey::PKeyError
        current_user.errors.add(:encrypt_key_pem, "Password supplied must have encrypted this file")
        return render :start_import
      end

      current_user.encrypt_key_pem = encrypt_key_pem
    end
    if sign_key_file = import_params["sign_key_pem"]
      sign_key_pem = sign_key_file.read
      begin
        sign_key = OpenSSL::PKey.read(sign_key_pem, import_params["password"])
      rescue OpenSSL::PKey::PKeyError
        current_user.errors.add(:sign_key_pem, "Password supplied must have encrypted this file")
        return render :start_import
      end

      current_user.sign_key_pem = sign_key_pem
    end
    current_user.save!

    redirect_to edit_profile_path, notice: "New private keys have successfully been imported."
  end

  def start_export
  end

  def export
    pkey_params = params.require("profile_export")

    unless current_user.authenticate(pkey_params["password"])
      current_user.errors.add(:password, "is invalid")
      return render :start_pkey
    end

    case pkey_params["usage"]
    when ["encrypt", "sign"] then
      buffer = Zip::OutputStream.write_buffer do |out|
        out.put_next_entry("#{current_user.name.gsub(' ', '_')}_keys/encrypt_key.pem")
        out.write(current_user.encrypt_key_pem)

        out.put_next_entry("#{current_user.name.gsub(' ', '_')}_keys/sign_key.pem")
        out.write(current_user.sign_key_pem)
      end
      send_data buffer.string, filename: "#{current_user.name.gsub(' ', '_')}_keys.zip", type: "application/zip"

    when ["encrypt"] then
      send_data current_user.encrypt_key_pem,
                filename: "#{current_user.name.gsub(' ', '_')}_encrypt_key.pem",
                type: "application/x-pem-file"

    when ["sign"] then
      send_data current_user.sign_key_pem,
                filename: "#{current_user.name.gsub(' ', '_')}_sign_key.pem",
                type: "application/x-pem-file"

    else
      render :start_pkey
    end
  end

  def start_genpkey
  end

  def genpkey
    genpkey_params = params.require("profile_genpkey")

    unless current_user.authenticate(genpkey_params["password"])
      current_user.errors.add(:password, "is invalid")
      return render :start_genpkey
    end

    def key_generation(genpkey_params)
      case genpkey_params["algorithm"]
      when "RSA" then OpenSSL::PKey::RSA.generate(genpkey_params["keysize"].to_i)
      when "DSA" then OpenSSL::PKey::DSA.generate(genpkey_params["keysize"].to_i)
      when "ECDSA" then OpenSSL::PKey::EC.generate(genpkey_params["curve"])
      end
    end

    if genpkey_params["usage"].include? "encrypt"
      current_user.set_encrypt_key key_generation(genpkey_params["encrypt"]), genpkey_params["password"]
    end

    if genpkey_params["usage"].include? "sign"
      current_user.set_sign_key key_generation(genpkey_params["sign"]), genpkey_params["password"]
    end

    current_user.save!

    redirect_to edit_profile_path, notice: "New private keys have successfully been generated."
    end
end
