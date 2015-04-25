var ready;

ready = function() {
	var major_ajax = $.ajax();

	$("#major-name").bind("change", function() {
		$("#major-requirements-list").empty();
		var value = $(this).find(":selected").val();
		if (value == "") {
			return;
		}
		major_ajax.abort();
		major_ajax = $.ajax({
			url: '/majors/',
			dataType: 'json',
			type: 'GET',
			success: function(data) {
				$.each(data, function() {
					if (this.last_name[0] == value) {
						$('#prof_list').append($("<a/>", {
							href: "/professors/" + this.id,
							text: this.last_name + ", " + this.first_name
						}));
						$('#prof_list').append($("<br/>", {}));
					}
				});
			}
		});
	});
};

$(document).ready(ready);

$(document).on('page:load', ready);