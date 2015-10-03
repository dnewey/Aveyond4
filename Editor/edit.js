
// --------------------------------------------------------------------------------
// Variables
// --------------------------------------------------------------------------------

var $data_type = 'items'; 

var $meta_data = 0;
var $json_data = [];

var $tbl_offset = 0;
var $tbl_per_page = 11;
var $tbl_sorting = "";

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------

$(function()
{
    // Get the datatype from the url, default to something
    $data_type = location.search.replace('?', '').split('=')[1];
    if (!$data_type)
        $data_type = 'items';

    // Load up the meta data
    var request = $.ajax(
    {
        url: 'meta/'+$data_type+'.json',
        type: "GET",
        data: {},
        async: false,
        dataType: "json"
    });

    request.done(function(data)
    {
        $meta_data = data
        $meta_data.push({"field": "tools"});
    });

    request.fail(function(jqXHR, textStatus)
    {
        console.log('meta/'+$data_type+'.json');
        console.log(textStatus);
        console.log(jqXHR);
    });

    // Load json data file
    var file;
    var idx = 50;
    while (idx >= 0)
    {
        file = 'json/'+$data_type+'('+idx+').json';
        if (idx == 0)
            file = 'json/'+$data_type+'.json';

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
            $json_data = data;
            idx = -1;
        });

        request.fail(function(jqXHR, textStatus)
        {
            idx -= 1;
        });
    }

    // Set up filter box
    for (var idx in $meta_data)
    {
        var fld = $meta_data[idx].field;
        var op = $('<option value="' + fld + '">' + fld + '</option>');
        $('#dan-filter-by').append(op);
    }
    $('#dan-filter-txt').keyup(function () { filterby($('#dan-filter-txt').val()); });
    
    // Buttons
    $('#dan-btn-create').click(function () { json_create(); });
    $('#dan-btn-create-rev').click(function () { json_create_rev(); });
    $('#dan-btn-rev').click(function () { json_rev(); });
    //$('#dan-btn-mod').click(function () { json_sortmodified(); });
    $('#dan-btn-allpp').click(function () { json_allpp(); });

    // Set up that table
    refresh_header();
    refresh_table();
    refresh_pages();    

    // Top of page display
    $('#dan-head-title').html($data_type.titleize()+" Data")
    $('#dan-head-sub').html("Don't forget to save!")

    $( document ).tooltip();

});

// --------------------------------------------------------------------------------
// Initialize
// --------------------------------------------------------------------------------
refresh_table = function()
{
    // Clear Html
    $('#dan-table tbody').html('');

    var fragment = document.createDocumentFragment();

    for (var row = $tbl_offset; row < $tbl_offset + $tbl_per_page; row++)
    {
        var tr = document.createElement('tr');

        // Fill in blank frows to stop pages display jumping up and down
        if (row >= $json_data.length)
        {            
            for (var idx in $meta_data) 
            {
                if ($meta_data[idx].field == "modified")
                    continue;

                var td = document.createElement('td');
                td.appendChild($('<a href="#">-</a>')[0]);
                tr.appendChild(td);
            }

            fragment.appendChild(tr);
            continue;
        }        
        

        // Fill in each column of the meta data

        for (var idx in $meta_data) 
        {
            // Don't draw the modified time field
            if ($meta_data[idx].field == "modified")
                continue;

            var td = document.createElement('td');
            var fld = $meta_data[idx].field;

            // Custom coloring by value, use first letter?
            if ($meta_data[idx].color == "true")
            {
                if ($json_data[row][fld])
                {
                    color = stringToColour($json_data[row][fld]);

                    var att = document.createAttribute("style");
                    att.value = "background:rgba("+color.r+","+color.g+","+color.b+","+0.3+")";                           
                    td.setAttributeNode(att);
                }
            }

            // Tools column
            if ($meta_data[idx].field == "tools")
            {
                var a = $('<a href="#" dan-row="' + row +'" dan-fld="'+fld+'">' + '<img title="Delete" src="assets/img/del.png" />' + '</a>');
                a.click(function(){json_delete($(this).attr('dan-row'));});
                td.appendChild(a[0]);
                
                var b = $('<a href="#" dan-row="' + row +'"">' + '<img title="Duplicate" src="assets/img/dup.png" />' +'</a>');
                b.click(function(){json_dup($(this).attr('dan-row'));});
                td.appendChild(b[0]);

                // Next column
                tr.appendChild(td);
                continue;
            }                        

            // If missing data, fill in with default value
            // This is to support changing meta data with existing data files
            if (!$json_data[row][fld])
                if ($meta_data[idx].default)
                    $json_data[row][fld] = $meta_data[idx].default;
                else
                    $json_data[row][fld] = "";

            // Create the content of the field, the clickable link
            var a = $('<a href="#">' + $json_data[row][fld] +'</a>');
            a.attr('dan-row',row);
            a.attr('dan-fld',fld)
            a.attr("data-title",$meta_data[idx].name);
            a.attr("title",$json_data[row][fld]) // Replace this after edit also

            // **********************************************************
            // Special Edit fields

            // Text area
            if ($meta_data[idx].edit == "area")
                a.attr("data-type","textarea");

            // Autocomplete icon names
            if ($meta_data[idx].edit == "icon")
                a.attr("data-type","typeaheadjs");

            // Select boxes
            if ($meta_data[idx].edit == "select")
            {           
                a.attr("data-source",build_select(fld));
                a.attr("data-type","select");
            }

            // Create as editable
            if ($meta_data[idx].edit != "none") {
                
                if ($meta_data[idx].edit != "select")
                {
                    a.editable
                    ({
                        typeahead: {
                            name: 'test',
                            prefetch: 'icons.json'
                        },
                        // emptytext: 'nil',
                        // display: function(value, response) {
                        //     return false;   //disable this method
                        // },
                        success: function (r, v) {
                            json_edit($(this),$(this).attr('dan-row'),$(this).attr('dan-fld'), v);
                        }
                    });
                }
                else // Editables don't overwrite truncated value
                {
                    a.editable
                    ({
                        emptytext: 'nil',
                        success: function (r, v) {
                            json_edit($(this),$(this).attr('dan-row'),$(this).attr('dan-fld'), v);
                        }
                    });
                }


                if ($json_data[row][fld] == "")
                    a.html("nil");
                else
                    a.html($json_data[row][fld].truncate());
            }

            // Add to row
            td.appendChild(a[0]);
            tr.appendChild(td);
        }

        fragment.appendChild(tr);
    }

    // Add to table body
    $('#dan-table tbody').append(fragment);

};

// --------------------------------------------------------------------------------
// Build select box
// --------------------------------------------------------------------------------

build_select = function(type)
{
    if (type == "chapter")
    {
        return '[{value: "chapter 1", text: "chapter 1"},' 
            + '{value: "chapter 2", text: "chapter 2"},'
            + '{value: "chapter 3", text: "chapter 3"},'
            + '{value: "chapter 4", text: "chapter 4"},'
            + '{value: "chapter 5", text: "chapter 5"},'
            + '{value: "chapter 6", text: "chapter 6"},'
            + '{value: "chapter 7", text: "chapter 7"},'
            + '{value: "chapter 8", text: "chapter 8"},'
            + '{value: "other", text: "other"}'
            + ']';
    }

    if (type == "category")
    {
        return '[{value: "items", text: "items"},' 
            + '{value: "cures", text: "cures"},'
            + '{value: "battle", text: "battle"},'
            + '{value: "keys", text: "keys"},'
            + '{value: "other", text: "other"}'
            + ']'
    }

    if (type == "geartype")
    {
        return '[{value: "weapon", text: "weapon"},' 
            + '{value: "misc", text: "misc"},'
            + '{value: "armor", text: "armor"},'
            + '{value: "helm", text: "helm"},'
            + '{value: "acc", text: "acc"},'
            + ']'
    }

    if (type == "scope")
    {
        return '[{value: "one", text: "one"},' 
            + '{value: "rand", text: "rand"},'
            + '{value: "two", text: "two"},'
            + '{value: "three", text: "three"},'
            + '{value: "all", text: "all"},'
            + '{value: "ally", text: "ally"},'
            + '{value: "allies", text: "allies"},'
            + '{value: "party", text: "party"},'
            + '{value: "down", text: "down"},'
            + '{value: "self", text: "self"},'
            + '{value: "any", text: "any"},'
            + '{value: "common", text: "common"},'
            + ']'
    }

}

// --------------------------------------------------------------------------------
// Rebuild the table header
// --------------------------------------------------------------------------------

refresh_header = function()
{
    // Clear the head
    $('#dan-table thead tr').html('');

    // Add th for each col
    for (var idx in $meta_data)
    {
        if ($meta_data[idx].field == "modified")
            continue;

        var th = document.createElement('th');
        var att = document.createAttribute("style");
        att.value = "padding-left: 2px; padding-right: 2px";                           
        th.setAttributeNode(att);

        var fld = $meta_data[idx].field;
    
        var hlp = "";
        if ($meta_data[idx].help)
        {
            hlp = $meta_data[idx].help;
        }

        // Create the header button
        var btn = $('<input title="'+hlp+'" style="padding: 2px 5px 2px 5px; width:100%; font-weight: bold; font-size: 15px" type="button" dan-fld="' +
                    fld + '" class="btn btn-primary" value="' +
                    fld + '"/>');

        // Sort on click
        btn.click(function() { return sort_table($(this).attr('dan-fld')); });

        // Add the button to the html
        th.appendChild(btn[0]);
        $('#dan-table thead tr').append(th);
    }
};

// --------------------------------------------------------------------------------
// Refresh page display below table
// --------------------------------------------------------------------------------

refresh_pages = function()
{

    $('#dan-pages').html('');
    var pages = ($json_data.length-1) / $tbl_per_page;

    for (var idx = 0; idx <= pages; idx++)
    {
        // Create button
        var btn = $('<input type="button" dan-idx="' + idx +
                '" class="ui-button-primary button" value="' + (idx
                + 1) + '"/>');

        // Clickable
        btn.click(function()
        {
            $tbl_offset = $(this).attr('dan-idx') * $tbl_per_page;
            refresh_table();
        });

        // Add to page
        $('#dan-pages').append(btn);
    }

    $("#dan-pages").buttonset();
    $('#dan-info').html('Total records: '+$json_data.length);

};

// --------------------------------------------------------------------------------
// Modify json data
// --------------------------------------------------------------------------------

json_edit = function(element,row,fld, val)
{
    $json_data[row][fld] = val;
    date = new Date();
    //$json_data[row]['modified'] = date.getTime().toString();

    element.attr("title",val) // Only if it will be cut off but

    if (val == "")
        element.html("nil");
    else
        element.html(val.truncate());

    refresh_json();
};

// --------------------------------------------------------------------------------
// Build filter data
// --------------------------------------------------------------------------------

filterby = function(flt)
{
    filter_by = $('#dan-filter-by').val();
    $json_data.sort(function(a,b)
    {
        return string_similarity(a[filter_by],flt) < string_similarity(b[filter_by],flt);
    });    
    refresh_table();
}

// --------------------------------------------------------------------------------
// Create a new record
// --------------------------------------------------------------------------------

json_create = function()
{
    var obj = new Object();
    for (var idx in $meta_data)
    {
        var fld = $meta_data[idx].field;
        var val = $meta_data[idx].default;
        obj[fld] = val;
    }

    date = new Date();
    obj['modified'] = date.getTime().toString();

    $json_data.push(obj);

    refresh_json();
    refresh_pages();
    refresh_table();
};

json_create_rev = function()
{
    var obj = new Object();
    for (var idx in $meta_data)
    {
        var fld = $meta_data[idx].field;
        var val = $meta_data[idx].default;
        obj[fld] = val;
    }

    date = new Date();
    obj['modified'] = date.getTime().toString();

    $json_data.unshift(obj);

    refresh_json();
    refresh_pages();
    refresh_table();
};

// --------------------------------------------------------------------------------
// Reverse the table
// --------------------------------------------------------------------------------

json_rev = function()
{
    $json_data.reverse();
    refresh_table();
}

// --------------------------------------------------------------------------------
// Sort by last modified 2015-10-03
// --------------------------------------------------------------------------------

json_sortmodified = function()
{
    console.log("asdfasdf");
    sort_table("modified");
    refresh_table();
}

// --------------------------------------------------------------------------------
// Toggle showing all records vs pages
// --------------------------------------------------------------------------------

json_allpp = function()
{
    $tbl_offset = 0;

    if ($tbl_per_page == $json_data.length)
        $tbl_per_page = 11;
    else
        $tbl_per_page = $json_data.length;

    refresh_table();
    refresh_pages();
}

// --------------------------------------------------------------------------------
// Duplicate chosen record
// --------------------------------------------------------------------------------

json_dup = function(row)
{   
    data = JSON.parse(JSON.stringify($json_data[row]))
    $json_data.splice(row,0,data);

    refresh_json();
    refresh_table();
    refresh_pages();
};

// --------------------------------------------------------------------------------
// Delete chosen record
// --------------------------------------------------------------------------------

json_delete = function(row)
{
    $json_data.splice(row,1)

    refresh_json();
    refresh_table();
    refresh_pages();
};

// --------------------------------------------------------------------------------
// Refresh json data for the save button
// --------------------------------------------------------------------------------

refresh_json = function()
{
    var json = JSON.stringify($json_data);
    var blob = new Blob([json],{type: 'application/json'});
    var url = URL.createObjectURL(blob);
    $("#dan-head-btn").attr("download", $data_type + ".json");
    $("#dan-head-btn").attr("href", url);
};

// --------------------------------------------------------------------------------
// Sort the table
// --------------------------------------------------------------------------------

sort_table = function(col)
{
    if (col === $tbl_sorting)
    {
        $json_data.sort(sort_by(col, false));
        $tbl_sorting = "";
    }
    else
    {
        $json_data.sort(sort_by(col, true));
        $tbl_sorting = col;
    }
    refresh_table();
};

// --------------------------------------------------------------------------------
// Sort by function for sorting the table
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
// String sorting function
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

// --------------------------------------------------------------------------------
// String funcs
// --------------------------------------------------------------------------------

String.prototype.titleize = function() {
  var words = this.split(' ')
  var array = []
  for (var i=0; i<words.length; ++i) {
    array.push(words[i].charAt(0).toUpperCase() + words[i].toLowerCase().slice(1))
  }
  return array.join(' ')
}

String.prototype.truncate = function(){
    if(this.length > 25) {
        return this.substring(0,24)+"...";
    }
}

var stringToColour = function(str) {

    // str to hash
    for (var i = 0, hash = 0; i < str.length; hash = str.charCodeAt(i++) + ((hash << 5) - hash));

    // int/hash to hex
    for (var i = 0, colour = "#"; i < 3; colour += ("00" + ((hash >> i++ * 8) & 0xFF).toString(16)).slice(-2));

    return hexToRgb(colour);
}

function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}