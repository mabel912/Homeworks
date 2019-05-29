// from data.js
var tableData = data;

// YOUR CODE HERE!
// Get reference to table body
var tbody = d3.select("tbody");
//console.log(tableData);


//use d3 to append one table row 'tr'
tableData.forEach(function(ufoSightings) {
    //console.log(ufosightings);
    var row = tbody.append('tr');
    //use 'object.entries' to console.log each value
    Object.entries(ufoSightings).forEach(function([key, value]) {
        //console.log(key, value);
        //append a cell to the row for each value
        var cell = row.append('td');
        cell.text(value);
    });

});

//Select the filter button
var filterButton = d3.select("#filter-btn");
//Select D3 '.on' to attach a click handler for the filter
filterButton.on("click", function() {
    //alert("clicked!");
    d3.event.preventDefault();
    var dateInput = d3.select("#datetime");
    var dateToFilter = dateInput.node().value;
    //alert("dateToFilter");

    //custom function
    function onDate(ufoSightings) {
        return ufoSightings.datetime === dateToFilter;
    }
    //call custom function with filter()
    var filteredUFOData = tableData.filter(onDate);
    //console.log(ufoSightingsOnDate);
    tbody.html("");
    filteredUFOData.forEach(function(ufoSightings) {
        //console.log(ufoSightings);
        var row = tbody.append('tr');
        Object.entries(ufoSightings).forEach(function([key, value]) {
            var cell = row.append('td');
            cell.text(value);
        });
    });

});