TwitterEvents.tweets = {

    settings: {
        source: null,
        container: document.getElementById("js-tweets"),
        dummyNode: document.createElement("div"),
        template: Handlebars.compile(document.getElementById("tweet-template").innerHTML),
        startButton: document.getElementById("js-start-tweets"),
        stopButton: document.getElementById("js-stop-tweets")
    },

    init: function() {
        this.addListeners();
        this.bindUIActions();
    },

    addListeners: function() {
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
            TwitterEvents.tweets.render(event);
        });
    },

    render: function(event) {
        var tweet = JSON.parse(event.data),
            container = this.settings.container,
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

    stop: function() {
        var source = this.settings.source;
        if (source !== null) {
            source.close();
            source.removeEventListener("message", TwitterEvents.tweets.render);
            this.settings.source = null;
        }
    }

}
