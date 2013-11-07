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
        TwitterEvents.tweets.startTweets();
    },

    bindUIActions: function() {
        this.settings.stopTweetsButton.on("click", function() {
            TwitterEvents.tweets.stopTweets();
        });
    },

    startTweets: function() {
        this.settings.source = new EventSource("/tweets");
        this.settings.source.addEventListener("message", TwitterEvents.tweets.renderTweets);
    },

    renderTweets: function(event) {
        var data = JSON.parse(event.data);
        console.log(data);
    },

    stopTweets: function() {
        var source = this.settings.source;
        source.close();
        source.removeEventListener("message", TwitterEvents.tweets.renderTweets);
        this.settings.source = null;
    }

}
