require 'test_helper'

class IndexTest < ActionDispatch::IntegrationTest
  def test_success_root
    get '/'

    assert_response :success
    assert_template :index
    directory = assigns(:directory)
    assert_equal Dir.entries('.').sort, directory.map { |d| d[:relative] }.sort
  end

  def test_success_file
    filename = 'Gemfile'
    get "/#{filename}"

    assert_response :success
    assert_template :file
    assert_equal File.read(filename), assigns(:file)
  end

  def test_out_of_directory_access
    assert_raise(ArgumentError) do
      get "/../../test"
    end
  end

  def test_move
    old_filename = 'tmp/myfile'
    new_filename = 'tmp/movedfile'
    FileUtils.touch old_filename

    put "/#{old_filename}", params: { new_name: new_filename }

    assert_response :success
    assert File.exists?(new_filename)
    assert !File.exists?(old_filename)
  ensure
    FileUtils.rm_rf old_filename
    FileUtils.rm_rf new_filename
  end

  def test_delete_file
    file_to_delete = 'tmp/new_file_to_delete'
    FileUtils.touch file_to_delete
    assert File.exists?(file_to_delete)

    delete "/#{file_to_delete}"
    assert_response :success
    assert !File.exists?(file_to_delete)
  end

  def test_upload
    filename = 'Gemfile'
    uploaded_filename = "tmp/#{filename}"
    assert !File.exists?(uploaded_filename)
    post '/tmp/', params: { file: Rack::Test::UploadedFile.new(filename, 'text/plain') }
    assert File.exists?(uploaded_filename)
  ensure
    FileUtils.rm_rf uploaded_filename
  end
end
