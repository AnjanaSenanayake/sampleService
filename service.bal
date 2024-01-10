import ballerina/http;
import ballerina/log;
import ballerina/url;

json openidConfiguration;

function init() returns error? {
    log:printInfo("Retrieving openid configuration started");
    string discoveryEndpointUrl = check url:decode("https://api.asgardeo.io/t/bifrost/oauth2/token/.well-known/openid-configuration", "UTF8");
    http:Client discoveryEpClient = check new (discoveryEndpointUrl.toString());
    openidConfiguration = check discoveryEpClient -> get("/");
    log:printInfo("Retrieving openid configuration ended");
}

service / on new http:Listener(9090) {
    resource function get transform(http:RequestContext ctx, http:Request request) returns http:Response {
        http:Response response = new;
        response.setPayload(openidConfiguration);
        response.statusCode = http:STATUS_OK;
        return response;
    }
}
