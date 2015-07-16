var source;

source = new EventSource('/messages/events');

source.addEventListener('message', function(e) {
  var message;
  message = $.parseJSON(e.data).body;
  user = localStorage.getItem('username-human-touch')
  $('#chat').prepend($("<li>" + user + ": " + message + '</li>'));
  $('#chat-field').val('');
});
