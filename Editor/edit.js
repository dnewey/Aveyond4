
var data_type = 'items';

var icon_data = []

var meta_data = 0;
var json_data = 0;
var filter_data = 0;

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
    data_type = type

    // Load up the meta data
    var request = $.ajax(
        {
            url: 'meta/'+type+'.json',
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
        console.log('meta/'+type+'.json');
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
        filterby($('#dan-filter').val());
    });

    $('#dan-create').click(function ()
    {
        console.log("CR");
        json_create();
    });

    refresh_header();
    refresh_table();
    refresh_pages();

    // Top of page display
    $('#DanTitle').html(data_type.titleize()+" Data")
    $('#DanSub').html("Don't forget to save!")

    $("#THEBTN").attr("download", data_type + ".json");

    localStorage.clear();

    $('.tip').tipr();

});

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
refresh_table = function()
{
    // Clear Html
    $('#dantable tbody').html('');

    var fragment = document.createDocumentFragment();


    for (var row = tbl_offset; row < tbl_offset + tbl_per_page; row++)
    {
        if (row >= json_data.length)
            break;

        var tr = document.createElement('tr');

        // Add function column, copy and delete

        for (var idx in meta_data) {

            var td = document.createElement('td');

            var fld = meta_data[idx].field;

            if (!json_data[row][fld])
                if (meta_data[idx].default)
                    json_data[row][fld] = meta_data[idx].default;
                else
                    json_data[row][fld] = "";

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
            }

            if (meta_data[idx].edit == "area")
            {
                
                a.attr("data-type","textarea");
            }

            if (meta_data[idx].edit == "icon")
            {
                a.attr("data-type","typeaheadjs");
                //a.attr("data-strings",icon_data);
            }                

            if (meta_data[idx].edit == "select")
            {
                //console.log("doingsrc")
                options = '[{value: "Chapter 1", text: "Chapter 1"},' 
                            + '{value: "Chapter 2", text: "Chapter 2"},'
                            + '{value: "Chapter 3", text: "Chapter 3"},'
                            + '{value: "Chapter 4", text: "Chapter 4"},'
                            + '{value: "Chapter 5", text: "Chapter 5"},'
                            + '{value: "Chapter 6", text: "Chapter 6"},'
                            + '{value: "Chapter 7", text: "Chapter 7"},'
                            + '{value: "Chapter 8", text: "Chapter 8"},'
                            + '{value: "Potions", text: "Potions"}'
                            + ']'
                a.attr("data-source",options)
                a.attr("data-type","select");
            }

            //console.log(icon_data);

            // Create as editable
            if (meta_data[idx].edit != "none") {
                a.editable
                ({
                    typeahead: {
                        name: 'test',
                        prefetch: 'icons.json'
                    },
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

        var fld = meta_data[idx].field;

        // Create the header button
        var btn = $('<input style="width:100%;" type="button" dan-fld="' +
                    fld + '" class="ui-button-primary button" value="' +
                    fld + '"/>');

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
// Build filter data
// --------------------------------------------------------------------------------
filterby = function(flt)
{
    json_data.sort(function(a,b)
    {
        return string_similarity(a.name,flt) < string_similarity(b.name,flt);
    });    
    refresh_table();
}

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

    // Sort by reverse id to show latest added, and go page 1


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
    $("#THEBTN").attr("download", data_type + ".json");
    $("#THEBTN").attr("href", url);
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

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------

var get_bigrams, string_similarity;

get_bigrams = function(string) {
  var i, s, v, _i, _ref;
  s = string.toLowerCase();
  v = new Array(s.length - 1);
  for (i = _i = 0, _ref = v.length; _i <= _ref; i = _i += 1) {
    v[i] = s.slice(i, i + 2);
  }
  return v;
};

string_similarity = function(str1, str2) {
  var hit_count, pairs1, pairs2, union, x, y, _i, _j, _len, _len1;
  if (str1.length > 0 && str2.length > 0) {
    pairs1 = get_bigrams(str1);
    pairs2 = get_bigrams(str2);
    union = pairs1.length + pairs2.length;
    hit_count = 0;
    for (_i = 0, _len = pairs1.length; _i < _len; _i++) {
      x = pairs1[_i];
      for (_j = 0, _len1 = pairs2.length; _j < _len1; _j++) {
        y = pairs2[_j];
        if (x === y) {
          hit_count++;
        }
      }
    }
    if (hit_count > 0) {
      return (2.0 * hit_count) / union;
    }
  }
  return 0.0;
};



String.prototype.titleize = function() {
  var words = this.split(' ')
  var array = []
  for (var i=0; i<words.length; ++i) {
    array.push(words[i].charAt(0).toUpperCase() + words[i].toLowerCase().slice(1))
  }
  return array.join(' ')
}