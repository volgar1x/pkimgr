class ProfilesController < SecureController
  def edit
  end

  def update
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
  end

private
  def profile_params
    params.require(:profile).permit(:email, :firstname, :lastname, :street, :street2, :city, :zip, :country, :phone)
  end
end
