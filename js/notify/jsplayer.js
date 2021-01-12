(function($) {
    var player;
    var cacheSounds = {};

    $.jsPlayer = {};

    if(!player){
        buzz.defaults.formats = [ 'ogg', 'mp3' ];
        buzz.defaults.preload = true;
        if (buzz.isSupported()) {
            $.jsPlayer.buzz = player = buzz;
        }
    }

    $.jsPlayer.preload = function(playId){
        if(!player){
            return;
        }

        if(!cacheSounds[playId]){
            cacheSounds[playId] = new player.sound("../sounds/"+playId);
        }
    };

    $.jsPlayer.play = function(playId){
        $.jsPlayer.preload(playId);

        if(cacheSounds[playId])
            cacheSounds[playId].play();
    }

})(jQuery);