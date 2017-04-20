class IndexController < ApplicationController
  def index
    @directory = Dir.entries('.')
    @path = ''
  end

  def path
    check_path
    if File.directory?(params[:path])
      @directory = Dir.entries(params[:path])
      @path = "#{params[:path]}/"
      render :index
    elsif File.size(params[:path]) > 250_000
      send_file params[:path]
    else
      @file = File.read(params[:path])
      render :file
    end
  end

  def delete
    check_path
    if File.directory?(params[:path])
      FileUtils.rm_rf(params[:path])
    else
      FileUtils.rm(params[:path])
    end
    head 204
  end

  private

  def check_path
    current_directory = File.expand_path('.')
    path = File.expand_path(params[:path])
    unless path.starts_with?(current_directory)
      raise ArgumentError, 'Should not be parent of root'
    end
  end
end
