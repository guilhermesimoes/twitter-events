TwitterEvents.tweets = {

    state: {
        source: null,
        last_page: false
    },

    settings: {
        container: document.getElementById("js-tweets"),
        streamEnd: document.getElementById("js-stream-end"),
        dummyNode: document.createElement("div"),
        template: Handlebars.compile(document.getElementById("tweet-template").innerHTML),
        searchForm: document.getElementById("js-search-form"),
        searchPage: document.getElementById("js-search-page"),
        startButton: document.getElementById("js-start-stream"),
        stopButton: document.getElementById("js-stop-stream"),
        classificationButton: document.getElementById("js-classify"),
        classificationGroup: document.getElementById("js-classification-group"),
        classificationTweetId: document.getElementById("js-tweet-id"),
        classificationCategory: document.getElementById("js-category")
    },

    init: function() {
        this.addListeners();
        this.bindUIActions();
        this.hideUIElements();
    },

    addListeners: function() {
        $(this.settings.searchForm)
            .on("ajax:beforeSend", function(event, xhr, settings) {
                TwitterEvents.tweets.lastSearchPage(xhr);
            })
            .on("ajax:success", function(event, data, status, xhr) {
                TwitterEvents.tweets.renderSearch(data);
            });

        $(window).endlessScroll({
            ceaseFireOnEmpty: false,
            callback: function(fireSequence, pageSequence, scrollDirection) {
                $(TwitterEvents.tweets.settings.searchForm).submit();
            }
        });
    },

    bindUIActions: function() {
        this.settings.startButton.onclick = function() {
            TwitterEvents.tweets.startStream();
        };
        this.settings.stopButton.onclick = function() {
            TwitterEvents.tweets.stopStream();
        };
        this.settings.classificationButton.onclick = function() {
            TwitterEvents.tweets.startClassification();
        };
        this.settings.searchForm.onsubmit = function(event) {
            TwitterEvents.tweets.startSearch(event);
        }
        $("#js-classification-form")
        .on("click", ".js-category-button", function() {
            TwitterEvents.tweets.setCategoryId(this.getAttribute("data-id"));
        })
        .on("ajax:success", function() {
            TwitterEvents.tweets.newClassification();
        });
    },

    hideUIElements: function() {
        this.settings.container.style.display = "none";
        this.settings.streamEnd.style.display = "none";
        this.settings.classificationGroup.style.display = "none";
    },

    startStream: function() {
        this.hideUIElements();
        this.settings.container.innerHTML = "";
        this.settings.container.style.display = "block";
        this.state.source = new EventSource("/tweets/stream");
        this.state.source.addEventListener("message", function(event) {
            TwitterEvents.tweets.renderStream(JSON.parse(event.data));
        });
    },

    renderStream: function(data) {
        var container = this.settings.container,
            newNode = this.settings.template(data.tweet);

        $(container).prepend(newNode);
    },

    stopStream: function() {
        var source = this.state.source;
        if (source !== null) {
            source.close();
            source.removeEventListener("message", TwitterEvents.tweets.renderStream);
            this.state.source = null;
        }
    },

    startClassification: function() {
        this.hideUIElements();
        this.settings.container.innerHTML = "";
        this.settings.container.style.display = "block";
        this.settings.classificationGroup.style.display = "block";

        $.ajax({
            type: "GET",
            dataType: 'json',
            url: "/classifications/new",
            success: function(data, status, xhr) {
                TwitterEvents.tweets.renderClassification(data.tweet);
            }
        })
    },

    renderClassification: function(tweet) {
        var container = this.settings.container,
            newNode = this.settings.template(tweet);

        this.settings.classificationTweetId.value = tweet.id;
        this.settings.container.innerHTML = "";

        $(container).prepend(newNode);
    },

    setCategoryId: function(id) {
        this.settings.classificationCategory.value = id;
    },

    newClassification: function() {
        this.settings.classificationButton.click();
    },

    startSearch: function(event) {
        if (event.hasOwnProperty("srcElement")) { // new search
            this.settings.searchPage.value = 1;
            this.settings.last_page = false;
            this.hideUIElements();
            this.settings.container.innerHTML = "";
            this.settings.container.style.display = "block";
        }
    },

    renderSearch: function(data) {
        var container = this.settings.container,
            newNodes = "",
            tweets = data.tweets;

        if (data.meta.last_page) {
            this.settings.last_page = true;
        }
        else {
            var page = parseInt(this.settings.searchPage.value, "10");
            this.settings.searchPage.value = page + 1;
        }

        for (var i = 0, length = tweets.length; i < length; i++) {
            newNodes += this.settings.template(tweets[i]);
        }
        $(container).append(newNodes);
    },

    lastSearchPage: function(xhr) {
        if (this.settings.last_page) {
            xhr.abort();
            this.settings.streamEnd.style.display = "block";
        }
    }

}
