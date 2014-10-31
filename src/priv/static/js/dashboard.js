$(function() {

  function refreshRankings() {
    $.getJSON("/admin/rankings")
      .then(function(data) {
        for(var i in data) {
          var ranking = data[i];
          var area = $('#' + ranking.conference + ' .panel-body');
          if(area.find('input.' + ranking.emotion).length === 0) {
            area.append($('<div class="emotion"><span>' + ranking.emotion + ' (' + ranking.average +')</span><input class="' + ranking.emotion + '" /></div>'));
            area.find('input.' + ranking.emotion).slider({value: ranking.average, enabled: false, step: 0.5, tooltip: 'hide'});
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
    var $el = $(this);
    var conference = $el.attr('data-conference-name');
    var slug = $el.attr('data-conference-slug');
    var enabled = $el.prop('checked') && "1" || "0";
    $.post("/admin/disable-conference", {conference: conference, slug: slug, enabled: enabled});
  });

});
