class IndexController < ApplicationController
  BASE_DIRECTORY = ENV['BASE_DIRECTORY'] || '.'

  def index
    @directory = Dir.entries(BASE_DIRECTORY)
    @path = ''
    @absolute_path = BASE_DIRECTORY
  end

  def path
    check_path

    if File.directory?(@absolute_path)
      @directory = Dir.entries(@absolute_path)
      @path = "#{params[:path]}/"
      render :index
    elsif File.file?(@absolute_path)
      if File.size(@absolute_path) > 250_000
        send_file @absolute_path
      else
        @file = File.read(@absolute_path)
        render :file
      end
    end
  end

  def delete
    check_path

    if File.directory?(@absolute_path)
      FileUtils.rm_rf(@absolute_path)
    else
      FileUtils.rm(@absolute_path)
    end
    head 204
  end

  private

  def check_path
    current_directory = File.expand_path(BASE_DIRECTORY)
    @absolute_path = File.expand_path(params[:path], BASE_DIRECTORY)
    raise ActionController::RoutingError, 'Not Found' unless File.exists?(@absolute_path)

    unless @absolute_path.starts_with?(current_directory)
      raise ArgumentError, 'Should not be parent of root'
    end
  end
end
