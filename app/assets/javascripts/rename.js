function rename(name) {
  var new_name = prompt("Enter the new name for this element.", name);
  if (new_name != null) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("PUT", '/' + name, false);
    var data = new FormData();
    data.append("new_name", new_name);
    var csrf_token = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    var csrf_param = document
      .querySelector("meta[name='csrf-param']")
      .getAttribute("content");
    if (csrf_token && csrf_param) {
      data.append(csrf_param, csrf_token);
    }
    xmlHttp.send(data);
  }
  return false;
}
