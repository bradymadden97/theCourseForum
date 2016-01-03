var ready = function() {
	$('#report-bug').click(function() {
		$('#report-bug-modal').modal();
		$('input[name="url"]').val(window.location);
	});

	$('#report').click(function() {
		$.ajax('/bugs', {
			method: "POST",
			data: $('#bug').serialize(),
			success: function(response) {
				$('textarea[name="description"]').val('');
				alert("Thanks for your feedback!");
			}
		});
		$('#report-bug-modal').modal('hide');
	});

	//toggles between each div (announcement) in the nav bar header
	$("#announcements > div:gt(0)").hide();

	setInterval(function() { 
	  $('#announcements > div:first')
	    .fadeOut(1500)
	    .next()
	    .fadeIn(1500)
	    .end()
	    .appendTo('#announcements');
	},  5000);
}

$(document).ready(ready);
$(document).on('page:load', ready);