class PostsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  before_action :check_is_group_member, :only => [:new, :create, :edit, :update, :destroy]
  #before action :find_author_and_check_permission, :only => [:edit, :update, :destroy]
  #skip_before_action :find_author_and_check_permission, :only => [:new, :create], raise: false

  #def index
#    @posts = Post.all
#  end



  # def show
  #   @post = Post.find( params[:id])
  #
  #   @group = @post.group
  #
  # end



  def edit
    # find_author_and_check_permission
    find_author_and_check_permission


  end




  def new
    @group = Group.find( params[:group_id] )
    @post = Post.new
  end
  #End of method new



  def create
    @group = Group.find( params[:group_id] )
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      # create successfully
      redirect_to group_path( @group )
    else
      # exception handle
      render :new
    end

  end
  # End of method create



  def update
    # find_author_and_check_permission
    find_author_and_check_permission

    if @post.update(post_params)
      #redirect_to group_path( @group ), notice: "Post updating is successful."
      redirect_to account_posts_path, notice: "Post updating is successful."
    else
      render :edit
    end

  end



  def destroy
    find_author_and_check_permission

    @post = Post.find( params[:id] )
    @post.destroy
    flash[:alert] = "Post deleted."
    redirect_to account_posts_path
  end

  private

  def find_author_and_check_permission

    #Assign corresponding group object from group id in parameter list
    @group = Group.find( params[:group_id] )

    #Assign corresponding post object from (post) id in parameter list
    @post = Post.find( params[:id] )

    if current_user != @post.user
      redirect_to account_posts_path, alert: "Only original author can edit/update/delete the post."
    end

  end
  # End of method find_author_and_check_permission



  # Only group member can write a post
  def check_is_group_member
    @group = Group.find( params[:group_id] )

    if current_user.is_member_of?( @group ) == false
      redirect_to group_path( @group ), alert: "Only group member can write/edit/delete a post."
    end

  end
  #End of method check_is_group_member


  def post_params
    params.require( :post ).permit( :content )
  end

end
# End of class PostController
