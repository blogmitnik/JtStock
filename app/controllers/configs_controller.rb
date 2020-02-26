class ConfigsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	page = (params[:page] || 1).to_i
  	@post = Post.find(params[:my_post_id])
    @report = @post.mi_reports.find(params[:report_id])
    @station = @report.station
    @reports_for_cart = @post.mi_reports.where('station_id = ? AND published_at = ?', @report.station_id, @report.published_at).order("published_at DESC")
  	@reports = @reports_for_cart.page(page)
  end
end
