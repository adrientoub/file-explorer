class IndexController < ApplicationController
  BASE_DIRECTORY = ENV['BASE_DIRECTORY'] || '.'

  include ActionView::Helpers::NumberHelper

  def index
    populate_directory(BASE_DIRECTORY, '')
    check_path_exist('')
  end

  def path
    absolute_path = check_path_exist(params[:path])

    if File.directory?(absolute_path)
      populate_directory(absolute_path, "#{params[:path]}/")
      render :index
    elsif File.file?(absolute_path)
      if File.size(absolute_path) > 250_000
        send_file absolute_path
      else
        @file = File.read(absolute_path)
        render :file, formats: :html
      end
    end
  end

  def delete
    absolute_path = check_path_exist(params[:path])

    if File.directory?(absolute_path)
      FileUtils.rm_rf(absolute_path)
    else
      FileUtils.rm(absolute_path)
    end
    head 204
  end

  def rename
    absolute_path = check_path_exist(params[:path])
    new_path = safe_expand_path(params[:new_name])
    if File.exists?(new_path)
      head 403
    else
      parent = new_path.split('/')[0..-2].join('/')
      FileUtils.mkdir_p(parent)
      FileUtils.mv(absolute_path, new_path)

      head 204
    end
  end

  private

  def my_escape(string)
    string.gsub(/([^ a-zA-Z0-9_.-]+)/) do
      '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
    end
  end

  def populate_directory(current_directory, current_url)
    directory = Dir.entries(current_directory)
    @directory = directory.map do |file|
      real_path_absolute = "#{current_directory}/#{file}"
      stat = File.stat(real_path_absolute)
      is_file = stat.file?

      {
        size: (is_file ? (number_to_human_size stat.size rescue '-'): '-'),
        type: (is_file ? :file : :directory),
        date: (stat.mtime.strftime('%d %b %Y %H:%M') rescue '-'),
        relative: my_escape("#{current_url}#{file}").gsub('%2F', '/'),
        entry: "#{file}#{is_file ? '': '/'}",
        absolute: real_path_absolute
      }
    end.sort_by { |entry| "#{entry[:type]}#{entry[:relative]}" }
  end

  def safe_expand_path(path)
    current_directory = File.expand_path(BASE_DIRECTORY)
    tested_path = File.expand_path(path, BASE_DIRECTORY)

    unless tested_path.starts_with?(current_directory)
      raise ArgumentError, 'Should not be parent of root'
    end
    tested_path
  end

  def check_path_exist(path)
    @absolute_path = safe_expand_path(path)
    raise ActionController::RoutingError, 'Not Found' unless File.exists?(@absolute_path)
    @absolute_path
  end
end
