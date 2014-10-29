$(function() {

  function registerEmotion(emotion) {
    return function() {
      console.log($(this));
      var value = $(this).slider("getValue");
      localStorage && localStorage.setItem(emotion, value);
      $.post("register-emotion", {value: value, emotion: emotion});
    };
  }

  function getDefaultEmotionValue(emotion) {
    return localStorage && parseInt(localStorage.getItem(emotion)) || 5;
  }

  $('input#appreciation-slider').slider({
    value: getDefaultEmotionValue("appreciation")
  }).on("slideStop", registerEmotion("appreciation"));

  $('input#lost-slider').slider({
    value: getDefaultEmotionValue("lost")
  }).on("slideStop", registerEmotion("lost"));

  var socket = new Phoenix.Socket("/ws");
  socket.join("generic", "global", {}, function(channel) {

    channel.on("reload", function(message) {
      $('input#appreciation-slider, input#lost-slider').slider("disable");
      toastr.warning("The application is updating, please wait. This should only take a few seconds, your work has been saved.");

      setInterval(function() {
        $.getJSON("/version").then(function(data) {
          console.log("data : " + data.version);
          console.log("msg : " + message.current_version);
          if(message.current_version != data.version) {
            location.reload();
          }
        });
      }, 100);

    });

  });


});
