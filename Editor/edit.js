
var data_type = 'items';

var icon_data = []

var meta_data = 0;
var json_data = [];

var filter_by = "id"
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

        meta_data.push({"field": "tools"});
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
            file = 'json/'+type+'.json';
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
        json_create();
    });

    $('#dan-rev').click(function ()
    {
        json_rev();
    });

    $('#dan-mod').click(function ()
    {
        json_sortmodified();
    });

    $('#dan-allpp').click(function ()
    {
        json_allpp();
    });

    refresh_header();
    refresh_table();
    refresh_pages();

    refresh_filterby();

    // Top of page display
    $('#DanTitle').html(data_type.titleize()+" Data")
    $('#DanSub').html("Don't forget to save!")

    $("#THEBTN").attr("download", data_type + ".json");

    localStorage.clear();

   // $('.tip').tipr();

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
        {
            // Blank table
            var tr = document.createElement('tr');
            
            for (var idx in meta_data) {
                var td = document.createElement('td');
                var a = $('<a href="#">'
                        + '-'
                        +'</a>');

                td.appendChild(a[0]);
                tr.appendChild(td);
            }

            fragment.appendChild(tr);
            continue;
        }

        var tr = document.createElement('tr');
        

        // Add function column, copy and delete

        for (var idx in meta_data) {

            if (meta_data[idx].field == "modified")
                continue;

            var td = document.createElement('td');
            var fld = meta_data[idx].field;

            if (fld == "user")
            {

                var att = document.createAttribute("style");
                if (json_data[row][fld] == "rob")
                    att.value = "background-color:pink";                           
                else
                    att.value = "background-color:lightblue";                           
                td.setAttributeNode(att);
            }


            if (meta_data[idx].field == "tools")
            {
                var a = $('<a href="#" dan-row="' + row
                    +'" dan-fld="'+fld+'">'
                    + '<img title="Delete" src="assets/img/del.png" />'
                    +'</a>');
                a.click(function()
                {
                    json_delete($(this).attr('dan-row'));
                });

                // Add to row
                td.appendChild(a[0]);

                var b = $('<a href="#" dan-row="' + row +'"">'
                    + '<img title="Duplicate" src="assets/img/dup.png" />'
                    +'</a>');
                b.click(function()
                {
                    json_dup($(this).attr('dan-row'));
                });

                // Add to row
                td.appendChild(b[0]);

                tr.appendChild(td);

                continue;
            }                        

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

            if (meta_data[idx].edit == "chapter")
            {
                options = '[{value: "chapter 1", text: "chapter 1"},' 
                            + '{value: "chapter 2", text: "chapter 2"},'
                            + '{value: "chapter 3", text: "chapter 3"},'
                            + '{value: "chapter 4", text: "chapter 4"},'
                            + '{value: "chapter 5", text: "chapter 5"},'
                            + '{value: "chapter 6", text: "chapter 6"},'
                            + '{value: "chapter 7", text: "chapter 7"},'
                            + '{value: "chapter 8", text: "chapter 8"},'
                            + '{value: "other", text: "other"}'
                            + ']'
                a.attr("data-source",options)
                a.attr("data-type","select");
            }

            if (meta_data[idx].edit == "select")
            {
                options = '[{value: "items", text: "items"},' 
                            + '{value: "cures", text: "cures"},'
                            + '{value: "battle", text: "battle"},'
                            + '{value: "keys", text: "keys"},'
                            + '{value: "other", text: "other"}'
                            + ']'
                a.attr("data-source",options)
                a.attr("data-type","select");
            }

            if (meta_data[idx].edit == "geartype")
            {
                options = '[{value: "weapon", text: "weapon"},' 
                            + '{value: "misc", text: "misc"},'
                            + '{value: "armor", text: "armor"},'
                            + '{value: "helm", text: "helm"},'
                            + '{value: "acc", text: "acc"},'
                            + ']'
                a.attr("data-source",options)
                a.attr("data-type","select");
            }

            if (meta_data[idx].edit == "scope")
            {
                options = '[{value: "one", text: "one"},' 
                            + '{value: "two", text: "two"},'
                            + '{value: "three", text: "three"},'
                            + '{value: "all", text: "all"},'
                            + '{value: "ally", text: "ally"},'
                            + '{value: "party", text: "party"},'
                            + '{value: "down", text: "down"},'
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
                    emptytext: 'nil',
                    success: function (r, v) {
                        json_edit($(this).attr('dan-row'),$(this).attr('dan-fld'), v);
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

    $('.tip').tipr();

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
        if (meta_data[idx].field == "modified")
                continue;

        var th = document.createElement('th');
        var att = document.createAttribute("style");
            att.value = "padding-left: 2px; padding-right: 2px";                           
            th.setAttributeNode(att);

        var fld = meta_data[idx].field;

        // Create the header button
        var btn = $('<input style="padding: 2px 5px 2px 5px; width:100%; font-weight: bold; font-size: 15px" type="button" dan-fld="' +
                    fld + '" class="btn btn-primary" value="' +
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
    var pages = (json_data.length-1) / tbl_per_page;
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
    $("#dan-pages").buttonset();

    $('#dan-info').html('Total records: '+json_data.length);

};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
refresh_filterby = function()
{
    // Clear the head
    $('#dan-filter-by').html('');

    // Add th for each col
    for (var idx in meta_data)
    {
        var fld = meta_data[idx].field;

        // Create the header button
        var op = $('<option value="' +
                    fld + '">' +
                    fld + '</option>');

        // Define the sort function
        $('#dan-filter-by').on("change",function()
        {
            filter_by =  $('#dan-filter-by').val();
        });

        // Add the button to the html
        $('#dan-filter-by').append(op);
    }
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_edit = function(row,fld, val)
{
    json_data[row][fld] = val;
    date = new Date();
    json_data[row]['modified'] = date.getTime().toString();
    refresh_json();
};

// --------------------------------------------------------------------------------
// Build filter data
// --------------------------------------------------------------------------------
filterby = function(flt)
{
    json_data.sort(function(a,b)
    {
        return string_similarity(a[filter_by],flt) < string_similarity(b[filter_by],flt);
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

        obj[fld] = val;
        //console.log(obj);
    }

    date = new Date();
    obj['modified'] = date.getTime().toString();


    json_data.push(obj);

    // Sort by reverse id to show latest added, and go page 1


    refresh_json();
    refresh_pages();
    refresh_table();
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_rev = function()
{
    json_data.reverse();
    refresh_table();
}

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_sortmodified = function()
{
    console.log("asdfasdf");
    sort_table("modified");
    refresh_table();
}

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_allpp = function()
{
    tbl_offset = 0;

    if (tbl_per_page == json_data.length)
        tbl_per_page = 11;
    else
        tbl_per_page = json_data.length;

    refresh_table();
    refresh_pages();
}

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_dup = function(row)
{

    json_data.push(JSON.parse(JSON.stringify(json_data[row])));

    refresh_json();
    refresh_table();
    refresh_pages();
};

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
json_delete = function(row)
{
    json_data.splice(row,1)
    refresh_json();
    refresh_table();
    refresh_pages();
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