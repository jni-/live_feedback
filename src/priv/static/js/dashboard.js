$(function() {

  function refreshRankings() {
    $.getJSON("/admin/rankings")
      .then(function(data) {
        for(var i in data) {
          var ranking = data[i];
          var area = $('#' + ranking.conference);
          if(area.find('input.' + ranking.emotion).length === 0) {
            area.append($('<div><p>' + ranking.emotion + '</p><input class="' + ranking.emotion + '" /></div>'));
            area.find('input.' + ranking.emotion).slider({value: ranking.average, enabled: false, step: 0.5});
          } else {
            area.find('input.' + ranking.emotion).slider("setValue", ranking.average);
          }
        }
      });
  }

  refreshRankings();

  var socket = new Phoenix.Socket("/ws");
  socket.join("generic", "global", {}, function(channel) {
    channel.on("emotions-changed", refreshRankings);
  });


  // Hack, Calliope can't do conditions yet
  $('input[type=checkbox][data-enabled=1]').prop('checked', true);
  $('input[type=checkbox]').on('change', function() {
    // TODO activate/deactivate
    console.log("On doit activer? " + !!$(this).prop('checked'));
  });


});
