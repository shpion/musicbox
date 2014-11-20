// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

var notConvertedIds= '';
var intervalID = 0;

$(document).ready(function(){
    intervalID = setInterval(check_converted, 1000);
});

function check_converted(){
    if(notConvertedIds != '') {
        $.ajax({
            type: 'POST',
            dataType: "JSON",
            data: { ids: notConvertedIds},
            url: '/my_records/is_converted',
            success: function (data) {
                $(data).each(function (i) {
                    if (this.converted == 1) {
                        $("#convert-" + this.id).hide();
                        $("#audio-controls-" + this.id).show();
                        $("#size-" + this.id).html(fileSize(this.size));
                        notConvertedIds = notConvertedIds.replace(this.id + "#", "");
                    }
                    else if (this.converted == 2) {
                        $("#convert-" + this.id).hide();
                        $("#convert-error-" + this.id).show();
                        notConvertedIds = notConvertedIds.replace(this.id + "#", "");
                    }
                });
            }
        });
    }
    else
        clearInterval(intervalID);
}

function fileSize(size) {
    var i = Math.floor(Math.log(size) / Math.log(1024));
    return (size / Math.pow(1024, i)).toFixed(2) * 1 + ' '+['B', 'kB', 'MB', 'GB', 'TB'][i];
}