$(function() {

  function registerEmotion(emotion, conference) {
    return function() {
      var value = $(this).slider("getValue");
      localStorage && localStorage.setItem(emotion + conference, value);
      $.post("register-emotion", {value: value, emotion: emotion, conference: conference});
    };
  }

  function getDefaultEmotionValue(emotion, conference) {
    return localStorage && parseInt(localStorage.getItem(emotion + conference)) || 5;
  }

  $('.sliders').each(function() {
    var conference = $(this).attr('id');

    $(this).find('input#appreciation-slider').slider({
      value: getDefaultEmotionValue("appreciation", conference)
    }).on("slideStop", registerEmotion("appreciation", conference));

    $(this).find('input#lost-slider').slider({
      value: getDefaultEmotionValue("lost", conference)
    }).on("slideStop", registerEmotion("lost", conference));

  });

});
