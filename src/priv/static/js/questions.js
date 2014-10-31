$(function() {

  var commentEmotionName = "other";

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

  function saveComment(conference) {
    return function() {
      var $el = $(this);
      $.post("register-emotion", {value: $el.val(), emotion: commentEmotionName, conference: conference})
        .then(indicateValid($el));
    };
  }

  function saveCommentLocally(conference) {
    return function() {
      var $el = $(this);
      localStorage && localStorage.setItem(commentEmotionName + conference, $el.val());
    }
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
      value: parseInt(getDefaultEmotionValue("appreciation", conference, 5))
    }).on("slideStop", registerEmotion("appreciation", conference)).on('slideStart', function() { indicateLoading($(this)); });

    $(this).find('input#lost-slider').slider({
      value: parseInt(getDefaultEmotionValue("lost", conference, 5))
    }).on("slideStop", registerEmotion("lost", conference)).on('slideStart', function() { indicateLoading($(this)); });

    $(this).find('textarea')
      .val(getDefaultEmotionValue(commentEmotionName, conference, ""))
      .on('focus', function() { indicateLoading($(this)); })
      .on('keyup', saveCommentLocally(conference))
      .on('blur', saveComment(conference));

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
