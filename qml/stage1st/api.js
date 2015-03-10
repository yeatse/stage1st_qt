.pragma library

var API_BASE_URL = "http://bbs.saraba1st.com/2b/api/mobile/index.php";
var CategoryList = [];
var ForumList = [];

var XHRequest = function(method, url) {
    this.method = method || "GET";
    this.url = url || API_BASE_URL;
    this.query = "";
    this.postData = "";
};

XHRequest.prototype.setQuery = function(query) {
            for (var k in query) {
                this.query += this.query == "" ? "?" : "&";
                this.query += k + "=" + encodeURIComponent(query[k]);
            }
        };

XHRequest.prototype.setParams = function(params) {
            for (var k in params) {
                if (this.postData != "")
                    this.postData += "&";

                this.postData += k + "=" + encodeURIComponent(params[k]);
            }
        };

XHRequest.prototype.sendRequest = function(onSuccess, onFailure) {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                        if (xhr.readyState == XMLHttpRequest.DONE) {
                            if (xhr.status == 200) {
                                try {
                                    onSuccess(JSON.parse(xhr.responseText));
                                }
                                catch (e) {
                                    onFailure(e.toString());
                                }
                            }
                            else {
                                onFailure(xhr.status);
                            }
                        }
                    };
            xhr.open(this.method, this.url + this.query);
            if (this.method == "POST") {
                xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
                xhr.setRequestHeader("Content-Length", this.postData.length);
                xhr.send(this.postData);
            }
            else {
                xhr.send(null);
            }
        };

function getForumIndex(onSuccess, onFailure) {
    var req = new XHRequest;
    req.setQuery({module: "forumindex"});
    var s = function(resp) {
        CategoryList = resp.Variables.catlist;
        ForumList = resp.Variables.forumlist.sort(
                    function(l,r){return r.todayposts-l.todayposts}
                    );
        onSuccess();
    };
    req.sendRequest(s, onFailure);
}

function login(un, pw, onSuccess, onFailure) {
    var req = new XHRequest("POST");
    var query = {
        module: "login",
        loginsubmit: "yes",
        loginfield: "username"
    };
    var params = {
        username: un,
        password: pw,
        cookietime: 2592000
    };
    req.setQuery(query);
    req.setParams(params);
    var s = function(resp) {
        // success: messageval=location_login_succeed_mobile
        onSuccess(resp.Message.messagestr,
                  resp.Message.messageval);
    };
    req.sendRequest(s, onFailure);
}
