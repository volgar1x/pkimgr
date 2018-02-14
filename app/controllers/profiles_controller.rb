class ProfilesController < SecureController
  def edit
  end

  def update
    profile_params = params.require(:profile).permit(
      :email, :phone, :firstname, :lastname,
      :country, :state, :city, :zip,
    )

    unless current_user.authenticate(params[:profile][:password])
      current_user.errors.add(:password, "is invalid")
      return render :edit
    end

    respond_to do |format|
      if current_user.update(profile_params)
        format.html { redirect_to edit_profile_path, notice: 'Your profile was successfully updated.' }
        format.json { render :show, status: :ok, location: profile_path }
      else
        format.html { render :edit }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to new_session_path, notice: "Your profile has been deleted."
  end
end
