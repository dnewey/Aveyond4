
var data_type = 'items';

var meta_data = 0;
var json_data = 0;

var tbl_offset = 0;
var tbl_sorting = "";
var tbl_per_page = 11;
var tbl_filter = "";

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
$(function()
{
    // Get the datatype from the url, default to something
    var type = location.search.replace('?', '').split('=')[1];
    if (!type)
        type = "items";

    // Load up the meta data
    var request = $.ajax(
        {
            url: type+'-meta.json',
            type: "GET",
            data: {},
            async: false,
            dataType: "json"
        });

    request.done(function(data)
    {
        //console.log("gotit");
        meta_data = data
    });

    request.fail(function(jqXHR, textStatus)
    {
        console.log(type+'-meta.json');
        console.log(textStatus);
        console.log(jqXHR);
    });

    // Load json data file
    var file;
    var idx = 50;
    while (idx >= 0)
    {
        file = 'json/'+type+'('+idx+').json';
        if (idx == 0)
        {
            file = 'json/items.json';
        }
        //console.log(file);
        var request = $.ajax(
            {
                url: file,
                type: "GET",
                data: {},
                async: false,
                dataType: "json"
            });

        request.done(function(data)
        {
            //console.log("gotit");
            json_data = data;
            idx = -1;
        });

        request.fail(function(jqXHR, textStatus)
        {
            //console.log(textStatus);
            idx -= 1;
        });
    }

    $('#dan-filter').keyup(function ()
    {
        tbl_filter = $('#dan-filter').val();
        console.log($('#dan-filter').val());
        refresh_table();
    });
    $('#dan-create').click(function ()
    {
        console.log("CR");
        json_create();
    });

    refresh_header();
    refresh_table();
    refresh_pages();

});

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
refresh_table = function()
{
    // Clear Html
    $('#dantable tbody').html('');

    var fragment = document.createDocumentFragment();

    var count = 0;
    var row = 0;
    var skip = 0;
    while (row < json_data.length)
    {
        row = tbl_offset + count + skip;
        //console.log(tbl_filter);
        if (json_data[row].name == tbl_filter)
        {
            skip +=1;
            continue;
        }

        var tr = document.createElement('tr');

        for (var idx in meta_data) {

            var td = document.createElement('td');

            var fld = meta_data[idx].field;

            if (!json_data[row][fld])
                json_data[row][fld] = meta_data[idx].default;

            var a = $('<a href="#" dan-row="' + row
                    +'" dan-fld="'+fld+'">'
                    + json_data[row][fld]
                    +'</a>');

            // Define editable
            a.attr("data-title",meta_data[idx].name);
            if (meta_data[idx].edit == "list")
            {
                a.attr("data-value",0);
                a.attr("data-type","select");
                //var src = "[";
                //meta_data[idx].values
                //.attr("data-source",)
            }

            // Create as editable
            if (meta_data[idx].edit != "none") {
                a.editable
                ({
                    success: function (r, v) {
                        return json_edit($(this).attr('dan-row'),$(this).attr('dan-fld'), v);
                    }
                });
            }

            // Add to row
            td.appendChild(a[0]);
            tr.appendChild(td);
        }

        fragment.appendChild(tr);

        count += 1;
        if (count > tbl_per_page)
             break;
    }

    // Add to table body
    $('#dantable tbody').append(fragment);

};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
refresh_header = function()
{
    // Clear the head
    $('#dantable thead tr').html('');

    // Add th for each col
    for (var idx in meta_data)
    {
        var th = document.createElement('th');

        var col = meta_data[idx].name;
        var fld = meta_data[idx].field;

        // Create the header button
        var btn = $('<input style="width:100%;" type="button" dan-fld="' +
                    fld + '" class="ui-button-primary button" value="' +
                    col + '"/>');

        // Define the sort function
        btn.click(function()
        {
            return sort_table($(this).attr('dan-fld'));
        });

        // Add the button to the html
        th.appendChild(btn[0]);
        $('#dantable thead tr').append(th);
    }
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
refresh_pages = function()
{
    $('#dan-pages').html('');
    var pages = json_data.length / tbl_per_page;
    //pages -= 1;
    for (var idx = 0; idx <= pages; idx++)
    {
        // Create button
        var btn = $('<input type="button" dan-idx="' + idx +
                '" class="ui-button-primary button" value="' + (idx
                + 1) + '"/>');

        // Clickable
        btn.click(function()
        {
            tbl_offset = $(this).attr('dan-idx') *
            tbl_per_page;
            refresh_table();
        });

        // Add to page
        $('#dan-pages').append(btn);
    }
    return $("#dan-pages").buttonset();
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_edit = function(row,fld, val)
{
    json_data[row][fld] = val;
    refresh_json();
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_create = function()
{
    var obj = new Object();
    for (var idx in meta_data)
    {
        var fld = meta_data[idx].field;
        var val = meta_data[idx].default;

        if (fld == "id")
            val = json_data.length;

        obj[fld] = val;
        console.log(obj);
    }


    json_data.push(obj);

    refresh_json();
    refresh_pages();
    refresh_table();
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_dup = function(id)
{
    json_data[row][fld] = val;
    refresh_json();
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
refresh_json = function()
{
    var blob, json, url;
    json = JSON.stringify(json_data);
    blob = new Blob([json],
        {
            type: 'application/json'
        });
    url = URL.createObjectURL(blob);
    return $("#THEBTN").attr("href", url);
};


// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
sort_by = function(field, reverse, primer)
{
    var key;
    key = primer ? function (x) {
        return primer(x[field]);
    } : function (x) {
        return x[field];
    };
    reverse = [-1, 1][+(!!reverse)];
    return function(a, b)
    {
        a = key(a);
        b = key(b);
        return reverse * ((a > b) - (b > a));
    };
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
sort_table = function(col)
{
    if (col === tbl_sorting)
    {
        json_data.sort(sort_by(col, false));
        tbl_sorting = "";
    }
    else
    {
        json_data.sort(sort_by(col, true));
        tbl_sorting = col;
    }
    refresh_table();
};


