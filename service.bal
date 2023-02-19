import ballerina/log;
import ballerina/http;

configurable string countryBEUrl = "https://restcountries.com/v3.1/alpha";

service / on new http:Listener(9090) {
    resource function get countries/[string countryCode]() returns error|CountryResponse {
        http:Client httpEp = check new (url = countryBEUrl);
        Country[] countries = check httpEp->get(path = string `/${countryCode}`);

        if countries.length() == 0 {
            return error("No match found!");
        }
        var res = transform(countries[0]);
        log:printInfo("Response: ", res = res);
        return res;
    }
}

function transform(Country country) returns CountryResponse => {
    name: country.name.official,
    capital: country.capital[0],
    population: country.population
};

type Name record {
    string common;
    string official;
};

type Country record {
    Name name;
    string[] capital;
    string region;
    string subregion;
    int population;
    string[] timezones;
};

type CountryResponse record {
    string name;
    string capital;
    int population;
};
