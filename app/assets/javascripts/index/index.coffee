class @Index
  @delete = (path) ->
    $.ajax path,
      type: 'DELETE'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('body').append "Successful AJAX call: #{data}"
    false
