$(function() {

  function registerEmotion(emotion, conference) {
    return function() {
      $el = $(this);
      var value = $el.slider("getValue");
      localStorage && localStorage.setItem(emotion + conference, value);
      $.post("register-emotion", {value: value, emotion: emotion, conference: conference})
        .then(indicateValid($el));
    };
  }

  function getDefaultEmotionValue(emotion, conference, defaultValue) {
    return localStorage && localStorage.getItem(emotion + conference) || defaultValue;
  }

  function indicateLoading($el) {
    $el.closest(".sliders").find('.state').addClass("loading");
  }

  function indicateValid($el) {
    $el.closest(".sliders").find('.state').removeClass("loading");
  }

  $('.sliders').each(function() {
    var conference = $(this).attr('id');

    $(this).find('input#appreciation-slider').slider({
      value: parseInt(getDefaultEmotionValue("appreciation", conference, 5)),
      tooltip: "hide"
    }).on("slideStop", registerEmotion("appreciation", conference)).on('slideStart', function() { indicateLoading($(this)); });

    $(this).find('input#following-slider').slider({
      value: parseInt(getDefaultEmotionValue("following", conference, 5)),
      tooltip: "hide"
    }).on("slideStop", registerEmotion("following", conference)).on('slideStart', function() { indicateLoading($(this)); });

  });

  var socket = new Phoenix.Socket("/ws");
  socket.join("generic", "global", {}, function(channel) {

    channel.on("conference-toggled", function(message) {
      if(message.enabled) {
        location.reload();
      } else {
        $("#" + message.slug).animate({height: 0}, function() { $(this).remove(); });
      }

    });

  });

});
