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

  function activateControls(activate) {
    $('input#appreciation-slider, input#lost-slider').slider(activate ? "enable" : "disable");
  }

  function reloadPageIfVersionChanged(current_version) {
    $.getJSON("/version").then(function(data) {
      if(current_version != data.version) {
        location.reload();
      }
    });
  }

  $('input#appreciation-slider').slider({
    value: getDefaultEmotionValue("appreciation")
  }).on("slideStop", registerEmotion("appreciation"));

  $('input#lost-slider').slider({
    value: getDefaultEmotionValue("lost")
  }).on("slideStop", registerEmotion("lost"));



  var socket = new Phoenix.Socket("/ws");
  var socketWasDead = false;
  socket.join("generic", "global", {}, function(channel) {

    if(socketWasDead) {
      reloadPageIfVersionChanged($('p.version em'));
      activateControls(true);
      toastr.clear();
      toastr.success("Everything is back to normal!");
    }

    channel.on("reload", function(message) {
      activateControls(false);
      toastr.warning("The application is updating, please wait. This should only take a few seconds, your work has been saved.");

      setInterval(function() {
        reloadPageIfVersionChanged(message.current_Version);
      }, 100);

    });

  });

  socket.onClose(function() {
      activateControls(false);
      if(!socketWasDead) {
        toastr.error("The server seems to be going through some rough times.", "Please be supportive in this moment of hardsip.", {timeOut: 0});
      }
      socketWasDead = true;
  });


});
