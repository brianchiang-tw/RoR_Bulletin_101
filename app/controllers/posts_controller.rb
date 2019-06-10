class PostsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create]

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


  def post_params
    params.require( :post ).permit( :content )
  end

end
# End of class PostController
