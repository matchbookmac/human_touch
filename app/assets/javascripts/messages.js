var source;

source = new EventSource('/messages/events');

source.addEventListener('message', function(e) {
  var message;
  message = $.parseJSON(e.data).body;
  user = $.parseJSON(e.data).username;
  $('#chat').prepend($("<li>" + user + ": " + message + '</li>'));
  if(user === localStorage.getItem('username-human-touch')) {
    $('#chat-field').val('');
  }
});
