$(function() {

  function activateControls(activate) {
    $('input#appreciation-slider, input#following-slider').slider(activate ? "enable" : "disable");
    $('textarea').prop('disabled', !activate);
  }

  function reloadPageIfVersionChanged(current_version) {
    $.getJSON("/version").then(function(data) {
      if(current_version != data.version) {
        location.reload();
      }
    });
  }

  var socket = new Phoenix.Socket("/ws");
  var socketWasDead = false;
  var updating = false;
  socket.join("generic", "global", {}, function(channel) {

    if(socketWasDead) {
      reloadPageIfVersionChanged($('p.version em'));
      activateControls(true);
      toastr.clear();
      toastr.success("Everything is back to normal!");
    }

    channel.on("reload", function(message) {
      updating = true;
      activateControls(false);
      toastr.warning("The application is updating, please wait. This should only take a few seconds, your work has been saved.");

      setInterval(function() {
        reloadPageIfVersionChanged(message.current_Version);
      }, 100);

    });

  });

  socket.onClose(function() {
      activateControls(false);
      if(!socketWasDead && !updating) {
        toastr.error("The server seems to be going through some rough times.", "Please be supportive in this moment of hardsip.", {timeOut: 0});
      }
      socketWasDead = true;
  });


});
