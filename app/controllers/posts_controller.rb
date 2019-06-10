class PostsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create]
  before_action :check_is_group_member, :only => [:new, :create]

  def new
    @group = Group.find( params[:group_id] )
    @post = Post.new
  end

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


  # Only group member can write a post
  def check_is_group_member
    @group = Group.find( params[:group_id] )

    if current_user.is_member_of?( @group ) == false
      redirect_to group_path( @group ), alert: "Only group member can write a post."
    end

  end
  #End of method check_is_group_member


  def post_params
    params.require( :post ).permit( :content )
  end

end
# End of class PostController
