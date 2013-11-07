TwitterEvents.tweets = {

    settings: {
        source: new EventSource("/tweets")
    },

    init: function() {
        this.addListeners();
    },

    addListeners: function() {
        this.settings.source.addEventListener("tweet", function(event) {
            var data = JSON.parse(event.data);
            TwitterEvents.tweets.renderTweets(data);
        });
    },

    renderTweets: function(data) {
        console.log(data);
    }

}
