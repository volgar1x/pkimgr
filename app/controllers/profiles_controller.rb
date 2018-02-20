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
end
