TwitterEvents.tweets = {

    settings: {
        source: null,
        container: document.getElementById("js-tweets"),
        dummyNode: document.createElement("div"),
        template: Handlebars.compile(document.getElementById("tweet-template").innerHTML),
        searchForm: document.getElementById("js-search-form"),
        startButton: document.getElementById("js-start-tweets"),
        stopButton: document.getElementById("js-stop-tweets")
    },

    init: function() {
        this.addListeners();
        this.bindUIActions();
    },

    addListeners: function() {
        $(this.settings.searchForm).on('ajax:success', function(event, data, status, xhr) {
            TwitterEvents.tweets.renderMultiple(data);
        });
    },

    bindUIActions: function() {
        this.settings.startButton.onclick = function() {
            TwitterEvents.tweets.start();
        };
        this.settings.stopButton.onclick = function() {
            TwitterEvents.tweets.stop();
        };
    },

    start: function() {
        this.settings.source = new EventSource("/tweets/stream");
        this.settings.source.addEventListener("message", function(event) {
            TwitterEvents.tweets.render(JSON.parse(event.data));
        });
    },

    render: function(tweet) {
        var container = this.settings.container,
            dummyNode = this.settings.dummyNode,
            newNode = this.settings.template({
                id: tweet.id,
                username: tweet.user.screen_name,
                text: tweet.text
            });

        dummyNode.innerHTML = newNode;
        container.insertBefore(dummyNode.children[0], container.firstChild);
        dummyNode.innerHTML = "";
    },

    renderMultiple: function(tweets) {
        $.each(tweets, function(index, tweet) {
            TwitterEvents.tweets.render(tweet);
        });
    },

    stop: function() {
        var source = this.settings.source;
        if (source !== null) {
            source.close();
            source.removeEventListener("message", TwitterEvents.tweets.render);
            this.settings.source = null;
        }
    }

}
