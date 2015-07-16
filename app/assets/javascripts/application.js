// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

$(function () {
  resizeChatBox();

  if(localStorage.getItem('username-human-touch') === null) {
    localStorage.setItem('username-human-touch', $('#new_username').text())
  } else {
    $('#current_user').val(localStorage.getItem('username-human-touch'));
  }
  $('#new_username').remove();
  // $("#new_message").submit(function (e) {
  //   $('#chat-field').delay(100).val('');
  // })

  $(window).on('resize', function() {
    resizeChatBox();
  });
});

function resizeChatBox() {
  var height = window.innerHeight;
  $('.chat-box').css('height', height-150 );
  $('.chat-box ul').css('height', height-150 );
  // $('tr.mark-area').css('height', width/3 );
  // $('td.mark-area').css('line-height', (width/3 -25) + 'px');
};
