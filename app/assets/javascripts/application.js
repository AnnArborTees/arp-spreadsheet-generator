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
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function(){
    $('#mass_line_ink, #arp_ink').change(function(){
        if( $(this).val() == 'C'){
            alert('For Color, automatically assigning values\n Hightlight, Mask, Ink Volume, Transparency')
            $('#mass_line_highlight3, #arp_highlight3').val('0');
            $('#mass_line_mask3, #arp_mask3').val('0');
            $('#mass_line_highlightp, #arp_highlightp').val('0');
            $('#mass_line_maskp, #arp_maskp').val('0');
            $('#mass_line_ink_volume, #arp_ink_volume').val('10');
            $('#mass_line_transparency, #arp_transparency').attr('checked', false);
            $('#mass_line_transparency_red, #arp_transparency_red').val('0');
            $('#mass_line_transparency_green, #arp_transparency_green').val('0');
            $('#mass_line_transparency_blue, #arp_transparency_blue').val('0');
        } else if ( $(this).val() == 'cw') {
            alert('For Color and White, automatically assigning default values\n Hightlight, Mask, Ink Volume')
            $('#mass_line_highlight3, #arp_highlight3').val('7');
            $('#mass_line_mask3, #arp_mask3').val('3');
            $('#mass_line_highlightp, #arp_highlightp').val('1');
            $('#mass_line_maskp, #arp_maskp').val('3');
            $('#mass_line_ink_volume, #arp_ink_volume').val('0');
        } else if ( $(this).val() == 'W') {
            alert('For Color and White, automatically assigning default values\n Hightlight, Mask, Ink Volume')
            $('#mass_line_highlight3, #arp_highlight3').val('7');
            $('#mass_line_mask3, #arp_mask3').val('3');
            $('#mass_line_highlightp, #arp_highlightp').val('1');
            $('#mass_line_maskp, #arp_maskp').val('3');
            $('#mass_line_ink_volume, #arp_ink_volume').val('0');
        }
    });

    $('#mass_line_print_with_black_ink, #arp_print_with_black_ink').click(function(){
        if ( $(this).is(':checked') ) {
            $('#mass_line_cmy_gray, #arp_cmy_gray').prop('checked', false)
           // $(this).attr('checked', true)
        } else {
            $('#mass_line_cmy_gray, #arp_cmy_gray').prop('checked', true)
          //  $(this).attr('checked', false)
        }

    });
});

function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().before(content.replace(regexp, new_id));
}