TwitterEvents.tweets = {

    settings: {
        source: new EventSource("/tweets"),
        stopTweetsButton: $("#js-stop-tweets")
    },

    init: function() {
        this.addListeners();
        this.bindUIActions();
    },

    addListeners: function() {
        this.settings.source.onmessage = function(event) {
            var data = JSON.parse(event.data);
            TwitterEvents.tweets.renderTweets(data);
        };
    },

    bindUIActions: function() {
        this.settings.stopTweetsButton.on("click", function() {
            TwitterEvents.tweets.stopTweets();
        });
    },

    renderTweets: function(data) {
        console.log(data);
    },

    stopTweets: function() {
        this.settings.source.close();
    }

}
