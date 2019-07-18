// Store our API endpoint inside queryUrl
var queryUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson";
var queryPlates = "https://raw.githubusercontent.com/fraxen/tectonicplates/master/GeoJSON/PB2002_plates.json"

// Perform a GET request to the query URL
d3.json(queryUrl, function (data) {
    createFeatures(data.features);
});

function createFeatures(earthquake) {

    // Define a function we want to run once for each feature in the features array
    // Give each feature a popup describing the place , magnitude and time of the earthquake
    var earthquakes = L.geoJson(earthquake, {
    onEachFeature: function (feature, layer) {
        layer.bindPopup("<h3>" + feature.properties.place +
        "<br> Magnitude: " + feature.properties.mag +
        "</h3><hr><p>" + new Date(feature.properties.time) + "</p>");
    },
    pointToLayer: function (feature, latlng) {
        return new L.circle(latlng,
        {
            radius: circleRadius(feature.properties.mag),
            fillColor: getColor(feature.properties.mag),
            fillOpacity: .7,
            stroke: true,
            color: "black",
            weight: .5
        })
    }
    });
    // Sending our earthquakes layer to the createMap function
    createMap(earthquakes);
}

// Change the magnitude by a factor for the radius of the circle
function circleRadius(value) {
    return value * 15000
}
//Create color range for the circle diameter 
function getColor(d) {
    return d < 1 ? 'rgb(255,255,255)' :
        d < 2  ? 'rgb(255,225,225)' :
        d < 3  ? 'rgb(255,195,195)' :
        d < 4  ? 'rgb(255,165,165)' :
        d < 5  ? 'rgb(255,135,135)' :
        d < 6  ? 'rgb(255,105,105)' :
        d < 7  ? 'rgb(255,75,75)' :
        d < 8  ? 'rgb(255,45,45)' :
        d < 9  ? 'rgb(255,15,15)' :
                'rgb(255,0,0)';
}



function createMap(earthquakes) {

    // Define basemap layers
    var satelliteMap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v9/tiles/256/{z}/{x}/{y}?access_token={accessToken}", {
    id: "mapbox.satellite",
    accessToken: API_KEY
    });

    var grayscaleMap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/light-v9/tiles/256/{z}/{x}/{y}?access_token={accessToken}", {
    id: "mapbox.grayscale",
    accessToken: API_KEY
    });

    var Plates = new L.LayerGroup();
    // Add Fault lines data
    d3.json(queryPlates, function (plate) {
    // Adding our geoJSON data, along with style information, to the tectonicplates
    L.geoJson(plate, {
        weight: 2,
        color: "orange"
    })
        .addTo(Plates);
    });

    // Define a baseMaps object to hold our base layers
    var baseMaps = {
    "Satellite": satelliteMap,
    "Grayscale": grayscaleMap
    };

    // Create overlay object to hold our overlay layer
    var overlayMaps = {
    "Earthquakes": earthquakes,
    "Fault Lines" : Plates
    };

    // Create map, giving it the earthquakes, and plates layers to display on load
    var myMap = L.map("map", {
    center: [37.09, -95.71],
    zoom: 5,
    layers: [grayscaleMap, earthquakes]
    });
    // Create a layer control
    // Pass in our baseMaps and overlayMaps
    // Add the layer control to the map
    L.control
    .layers(baseMaps, overlayMaps, {
        collapsed: false
    }).addTo(myMap);

// Create a legend to display information about our map
var legend = L.control({position: 'bottomright'});

legend.onAdd = function (map) {

    var div = L.DomUtil.create('div', 'info legend'),
    grades = [0, 1, 2, 3, 4, 5, 6, 7, 8],
    labels = [];

    div.innerHTML+='Magnitude<br><hr>'

    // loop through our density intervals and generate a label with a colored square for each interval
    for (var i = 0; i < grades.length; i++) {
        div.innerHTML +=
            '<i style="background:' + getColor(grades[i] + 1) + '">&nbsp&nbsp&nbsp&nbsp</i> ' +
            grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
}

return div;
};

legend.addTo(myMap);

}








