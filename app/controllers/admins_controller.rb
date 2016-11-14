class AdminsController < ApplicationController
  
  skip_before_filter :authenticate, :only => ['new', 'create']
  before_filter :validate_admin, :except => ['new', 'create']
  before_filter :set_admin, :except => ['new', 'create']

  
  def new
    @admin = Admin.new
    session[:is_admin] = true
    render 'new'
  end
  
  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      session[:is_admin] = true
      session[:user_id] = @admin.id
      redirect_to admin_path(@admin.id), :notice => "You signed up successfully!"
    else
      render 'new', :notice => "Form is invalid"
    end
  end
  
  def edit
    render 'edit'
  end
  
  def update
    @admin.update_attributes!(admin_params)
    return redirect_to admin_path(@admin.id)
  end

  def show
    render 'show'
  end
  
  def approve
    @team = Team.find_by_id(params[:team_id])
    @team.approved = true
    @team.save!
    redirect_to admin_path(@admin)
  end
  
  def disapprove
    @team = Team.find_by_id(params[:team_id])
    @team.approved = false
    @team.save!
    redirect_to admin_path(@admin)
  end
  
  def team_list_email
    AdminMailer.team_list_email(@admin).deliver_now
    
    redirect_to admin_path(@admin)
  end
  
  private

  def validate_admin
    if !(session[:is_admin])
      redirect_to '/', :notice => "Permission denied"
    end
  end

  def set_admin
    @admin = Admin.find_by_id session[:user_id]
    if @admin.nil?
      session[:user_id] = nil
      session[:is_admin] = false
      return redirect_to '/'
    end
      
  end
  
  def admin_params
    params.require(:admin).permit(:name, :email, :password)
  end  
  
end
