class Admin::CertProfilesController < Admin::Controller
  before_action :set_cert_profile, except: [:index, :new, :create]

  # GET /cert_profiles
  # GET /cert_profiles.json
  def index
    @profiles = CertProfile.all
  end

  # GET /cert_profiles/1
  # GET /cert_profiles/1.json
  def show
  end

  # GET /cert_profiles/new
  def new
    @profile = CertProfile.new
  end

  # GET /cert_profiles/1/edit
  def edit
  end

  # POST /cert_profiles
  # POST /cert_profiles.json
  def create
    @profile = CertProfile.new params.require(:cert_profile).permit(:name)

    unless ["new", "create"].include? params["form_action"]
      action, action_arg = params["form_action"].split(" ", 2)

      case action
      when "edit_constraint"
        constraint = @profile.constraints.find(action_arg)
        constraint.update(value: params["cert_profile"]["constraints"][action_arg])

      when "destroy_constraint"
        constraint = @profile.constraints.find(action_arg)
        constraint.destroy

      when "create_constraint"
        @profile_constraint = CertProfileConstraint.new type: "add_extension", value: {}
        if params["cert_profile_constraint"]
          @profile_constraint.profile = @profile
          @profile_constraint.value = params["cert_profile_constraint"]["value"]
          @profile_constraint.type = "add_extension"
          @profile_constraint.save
          @profile.constraints << @profile_constraint
          @profile_constraint = nil
        end
      end

      return render :new
    end

    if @profile.save
      redirect_to admin_cert_profiles_path, notice: 'Profile was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /cert_profiles/1
  # PATCH/PUT /cert_profiles/1.json
  def update
    @profile.assign_attributes params.require(:cert_profile).permit(:name)

    unless ["edit", "update"].include? params["form_action"]
      action, action_arg = params["form_action"].split(" ", 2)
      case action
      when "edit_constraint"
        constraint = @profile.constraints.find(action_arg)
        constraint.update(value: params["cert_profile"]["constraints"][action_arg])
      when "destroy_constraint"
        constraint = @profile.constraints.find(action_arg)
        constraint.destroy
      when "create_constraint"
        @profile_constraint = CertProfileConstraint.new type: "add_extension", value: {}
        if params["cert_profile_constraint"]
          @profile_constraint.profile = @profile
          @profile_constraint.value = params["cert_profile_constraint"]["value"]
          @profile_constraint.type = "add_extension"
          @profile_constraint.save
          @profile.constraints << @profile_constraint
          @profile_constraint = nil
        end
      end
      return render :edit
    end

    if @profile.save
      redirect_to admin_cert_profiles_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /cert_profiles/1
  # DELETE /cert_profiles/1.json
  def destroy
    @profile.destroy
    redirect_to admin_cert_profiles_path, notice: 'Profile was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cert_profile
      @profile = CertProfile.find(params[:id])
    end
end
