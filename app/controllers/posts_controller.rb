class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
    @post = Post.new
    @user_groups = current_user.user_groups.all
    
  end

  def create
    @post = current_user.posts.build(params[:post])
    @user_groups = current_user.user_groups.find(params[:user_groups].keys.collect(&:to_i))
    @post.save
    @user_groups.each do |user_group|
      @post.user_groups<< user_group
      end      
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      flash[:error] = "Post not created!"
      #redirect_to root_url
      render 'posts/index'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_url
  end

  private

    def correct_user
      @post = current_user.posts.find(params[:id])
    rescue
      redirect_to root_url
    end
end