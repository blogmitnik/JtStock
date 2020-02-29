class YieldFilesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @post = Post.find(params[:my_post_id])
    page = (params[:page] || 1).to_i
    @files = @post.yield_files.order("published_at DESC").page(params[:page]).per(100)
  end

  def show
    @post = Post.find(params[:my_post_id])
    @file = @post.yield_files.find_by_id(params[:id])
    if @file
      if @file.file_name.include? "MI-INDEX"
        @station_id = @file.file_name[9, 2].to_i
        @reports = @post.mi_reports.where(station_id: @station_id, yield_file_id: @file).order("station_id ASC").page(params[:page]).per(100)
        puts @station_id
        puts @reports.count
      else
        @reports = @post.reports.where(yield_file_id: @file).order("station_id ASC").page(params[:page])
      end
    end
  end

  def destroy
    @post = Post.find(params[:my_post_id])
    #@reports = @post.mi_reports.order("published_at ASC").page(params[:page])
  	@file = @post.yield_files.find(params[:id])
    @file.destroy
    respond_to do |format|
      format.js { head :ok }
      format.html { redirect_to my_post_path(@post), notice: "Successfully removed '#{@file.file_name}'" }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    @post = Post.find(params[:my_post_id])
    if params[:file_ids]
      YieldFile.where(id: params[:file_ids]).destroy_all
      #YieldFile.destroy_all(id: params[:file_ids])
      respond_to do |format|
        format.js { head :ok }
        format.html { redirect_to my_post_yield_files_path(@post), notice: "Successfully removed #{params[:file_ids].count} selected files" }
        format.json { head :no_content }
      end
    end
  end
end
