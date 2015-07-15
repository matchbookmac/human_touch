var source;

source = new EventSource('/messages/events');

source.addEventListener('message', function(e) {
  var message;
  message = $.parseJSON(e.data).body;
  $('#chat').append($('<li>' + message + '</li>'));
});
