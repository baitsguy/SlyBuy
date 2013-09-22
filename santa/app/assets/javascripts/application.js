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
//= require turbolinks
//= require_tree .
$(document).ready(function(){
		$('#lightbox').hide();
		$('#home').height(1000);
		$('#friends').height(1000);
		$('#charity').height(1000);
		$('a').click(function(){
    $('html, body').animate({
        scrollTop: $( $.attr(this, 'href') ).offset().top
    }, 500);
    return false;
		});
		$('.charity').on('click',function() {
				$('#lightbox').fadeIn("fast");
				$('<input>').attr({type:'hidden',name:'charity',value:$(this).attr('id')}).appendTo('#charity_form');
		});
		$('body').click(function(e) {
				if(e.target.id == 'lightbox' || $('#lightbox').has(e.target).length != 0)
						return true;
				else 
						$('#lightbox').fadeOut('fast');
		});
  $('html,body').animate({scrollTop: $('#home').offset().top},'slow');

});

