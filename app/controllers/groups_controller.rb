class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end



  def show
    @group = Group.find(params[:id])

    # post is shown with descending time order
    # add paging, set one paging group as 5 pages
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5 )
  end



  def edit

    #find_group_and_check_permission

  end



  def new
    @group = Group.new
  end



  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      # Group creator is a member by default human intuition
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end

  end



  def update

    #find_group_and_check_permission

    if @group.update(group_params)
      redirect_to groups_path, notice: "Update success"
    else
      render :edit
    end

  end



  def destroy

    #find_group_and_check_permission

    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
  end

  def join
    @group = Group.find( params[:id] )

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "Welcome to join this group."
    else
      flash[:warning] = "You are a member of this group already."
    end

    redirect_to group_path( @group )

  end
  #End of method join


  def quit

    @group = Group.find( params[:id] )

    if current_user.is_member_of?( @group )
      current_user.quit!( @group )
      flash[:alert] = "Already drop out of this group."
    else
      flash[:warning] = "Not a member of this group. It is unmeaningful operation."
    end

    redirect_to group_path( @group )

  end
  #End of method quit

  private


  def find_group_and_check_permission
    @group = Group.find( params[:id] )

    if current_user != @group.user
      redirect_to groups_path, alert: "You don't have permission."
    end

  end


  def group_params
    params.require(:group).permit(:title, :description)
  end




end
