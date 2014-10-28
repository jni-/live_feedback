$(function() {

  function registerEmotion(emotion) {
    return function() {
      var value = $(this).slider("getValue");
      localStorage && localStorage.setItem(emotion, value);
      $.post("/register-emotion", {value: value, emotion: emotion});
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


});
