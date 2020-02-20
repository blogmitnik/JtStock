class MyPostsController < InheritedResources::Base
  defaults :resource_class => Post, :collection_name => 'posts', :instance_name => 'post'
  before_filter :authenticate_user!

  def index
    @posts = Post.find(:all, order: 'title')
    @files_count = YieldFile.find(:all).count
  end

  def show
    page = (params[:page] || 1).to_i
    @posts = Post.find(:all, order: 'title')
    @post = Post.find(params[:id])
    reports_by_all = @post.reports
    reports_count = @post.reports.count

    if reports_count > 0
      if params[:date] == 'today'
        if reports_count == 0
          redirect_to my_post_path(@post), alert: "No data found :("
          return
        else
          @reports_for_cart = get_today_yield(@post, reports_by_all)
        end
      elsif params[:date] == 'yesterday'
        if reports_count == 0
          redirect_to my_post_path(@post), alert: "No data found :("
          return
        else
          @reports_for_cart = get_yesterday_yield(@post, reports_by_all)
        end
      elsif params[:to_date].present? && params[:to_date] != ""
        if reports_count == 0
          redirect_to my_post_path(@post), alert: "No data found :("
          return
        else
          @reports_for_cart = get_custom_date_yield(@post, reports_by_all, params[:to_date])
        end
      else # Today
        @reports_for_cart = get_today_yield(@post, reports_by_all)
      end
      reports_tmp = @reports_for_cart
      @reports_for_cart = reports_tmp.order("published_at ASC")
      @reports = reports_tmp.order("station_id ASC").page(page)
    else
      respond_to do |format|
        format.js { head :ok }
        format.html { redirect_to my_posts_path, alert: "No data found :(" }
        format.json { head :no_content }
      end
    end

  end

  # def new
  #   @product = Product.find(params[:product_id])
  #   @post = Post.new
  # end

  # def create
  #   create! { product_my_posts_path }
  #   @post.user = current_user
  #   @post.product = Product.find(params[:product_id])
  #   @post.save
  # end

  # def edit
  #   @product = Product.find(params[:product_id])
  #   @post = Post.find(params[:id])
  # end

  # def update
  #   @product = Product.find(params[:product_id])
  #   @post = Post.find(params[:id])
  #   update! { product_my_post_path(@product, @post) }
  # end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.js { head :ok }
      format.html { redirect_to my_posts_path, notice: "#{@post.title} was removed :)" }
      format.json { head :no_content }
    end
  end

  protected

  def begin_of_association_chain
    current_user
  end

  def collection
    @posts ||= end_of_association_chain.order("updated_at DESC")
    # @posts ||= end_of_association_chain.page((params[:page] || 1).to_i)
  end

end
