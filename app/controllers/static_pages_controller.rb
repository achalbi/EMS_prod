class StaticPagesController < ApplicationController
 def home
    if signed_in?
=begin
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], :per_page => 8)
      # @group_feed_items = current_user.posts.paginate(page: params[:page])
	    @groupposts = Grouppost.find(:all, :conditions => {:group_id => current_user.user_groups.map{|a| a.group_id}})
      @group_feed_items = @groupposts.collect{|a| a.post}.uniq
      # @group_feed_items = @group_feed_items.
      @comments = Comment.new
      @post = @group_feed_items
=end
      
      @comm_id = current_user.usercommunities.where("is_admin=? OR invitation != ?", true, Uc_enum::JOINED ).collect(&:community_id)
      @comm_id << active_community.id
      @joined_communities = Community.where(['id IN (?) and id NOT IN (?)', current_user.joined_uc.collect(&:community_id), @comm_id]) 
      @selected_comm = []
      @selected_comm << active_community

      @post = Post.new
      @communities = Community.where('id IN (?) ', current_user.joined_uc.collect(&:community_id))
      @cu_ids = @communities.collect(&:id)
      @communityposts = Communitypost.where('community_id IN (?)', @cu_ids)
      @posts = @communityposts.paginate(page: params[:page], :per_page => 8).collect{|a| a.post}.uniq
    else
      @user = env['omniauth.identity'] ||= User.new
      @user.user_info = UserInfo.new
    end
  end
  
  def help
  end

  def about
  end

end
  