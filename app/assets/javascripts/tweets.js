TwitterEvents.tweets = {

    settings: {
        source: null,
        stopTweetsButton: $("#js-stop-tweets")
    },

    init: function() {
        this.addListeners();
        this.bindUIActions();
    },

    addListeners: function() {
        TwitterEvents.tweets.start();
    },

    bindUIActions: function() {
        this.settings.stopTweetsButton.on("click", function() {
            TwitterEvents.tweets.stop();
        });
    },

    start: function() {
        this.settings.source = new EventSource("/tweets");
        this.settings.source.addEventListener("message", TwitterEvents.tweets.render);
    },

    render: function(event) {
        var data = JSON.parse(event.data);
        console.log(data);
    },

    stop: function() {
        var source = this.settings.source;
        source.close();
        source.removeEventListener("message", TwitterEvents.tweets.render);
        this.settings.source = null;
    }

}