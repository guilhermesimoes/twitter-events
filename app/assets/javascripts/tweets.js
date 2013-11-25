TwitterEvents.tweets = {

    settings: {
        source: null,
        container: document.getElementById("js-tweets"),
        template: Handlebars.compile(document.getElementById("tweet-template").innerHTML),
        stopButton: document.getElementById("js-stop-tweets")
    },

    init: function() {
        this.addListeners();
        this.bindUIActions();
    },

    addListeners: function() {
        TwitterEvents.tweets.start();
    },

    bindUIActions: function() {
        this.settings.stopButton.onclick = function() {
            TwitterEvents.tweets.stop();
        };
    },

    start: function() {
        this.settings.source = new EventSource("/tweets");
        this.settings.source.addEventListener("message", function(event) {
            TwitterEvents.tweets.render(event);
        });
    },

    render: function(event) {
        var tweet = JSON.parse(event.data),
            container = this.settings.container,
            newNode = document.createElement("li"),
            newNodeContent = this.settings.template({
                id: tweet.id,
                username: tweet.user.screen_name,
                text: tweet.text
            });

        newNode.className = "tweet";
        newNode.innerHTML = newNodeContent;
        container.insertBefore(newNode, container.firstChild);
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
