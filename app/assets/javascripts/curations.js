var ready;

ready = function() {
	function course_compare(a, b) {
			var course1 = a.subdepartment.mnemonic + " " + a.course_number
			var course2 = b.subdepartment.mnemonic + " " + b.course_number

			if (course1.toUpperCase() < course2.toUpperCase()) return -1;
			if (course1.toUpperCase() > course2.toUpperCase()) return 1;
			return 0;
		}
		
	$("#subdept_select").bind("change", function() {
			// $("#prof_select").prop("disabled", true);
			$("#course_select").prop("disabled", false);
			$("#course_select").empty();
			// $("#prof_select").empty();
			var value = $(this).find(":selected").val();
			$.ajax({
				url: '/subdepartments/' + value,
				dataType: 'json',
				type: 'GET',
				success: function(data) {
					$("#courses").fadeIn("fast");
					data = data.sort(course_compare);
					$.each(data, function() {
						$('#course_select').append($("<option/>", {
							value: this.id,
							text: this.subdepartment.mnemonic + " " + this.course_number
						}));
					});

					course_select.selectedIndex = -1;

				}
			});

		});

	$('#search-query1').autocomplete({
		source: function(request, response) {
			$.ajax({
				url: '/scheduler/search',
				dataType: 'json',
				type: 'GET',
				data: {
					query: request.term,
					type: 'all'
				},
				success: function(data) {
					response($.map(data.results, function(item) {
						return {
							label: item.label,
							course_id: item.course_id
						}
					}));
				}
			});
		}
	});

}

$(document).ready(ready);
$(document).on('page:load', ready);