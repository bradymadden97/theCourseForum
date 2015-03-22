// All JavaScript needs to be loaded after the page has been rendered
// This is to ensure proper selection of DOM elements (jquery + bootstrap expansion)

// $ denotes jQuery - $(document) means we select the "document" or HTML page object
// We attach an anonymous function to be executed when the page is "ready" - all DOM elements are loaded
$(document).ready(function() {
	// Utility class to format strings for display
	var Utils = {
		// Converts date into a day of the week, using our base week reference of April - XX - 2015
		formatDateString: function(weekDay) {
			// Days of the week placeholder array
			var days = ['Mo', 'Tu', 'We', 'Th', 'Fr'],
				// Reference month defined (April 2014)
				dateString = '2014-04-';

			// Append to the date the selected day of the week - If monday, then date is 2014-04-14 (a Monday)
			dateString += (days.indexOf(weekDay) + 14);

			// Finally, return the date that corresponds to the passed in weekDay
			return dateString;
		},

		// Performs initial formatting from start time and end times to legible format
		// Responsible for output of: Mo 12:00PM - 1:45PM
		// Takes in a Course object, which has nested start_times and end_times in separate array properties
		// Will "pair" these start_times and end_times together
		formatTimeStrings: function(course) {
			// Placeholder array for pairs of start_times and end_times
			var times = [],
				// Initial string for the day - Mo, or Tu
				daysString = "",
				// Initial string for the time - 12:00PM - 1:45 PM
				timeString = "";

			// Each start_time corresponds to a separate day, stored in course.days or course['days']
			for (var i = 0; i < course.start_times.length; i++) {
				// Begin the time string with the corresponding day
				daysString += course.days[i];

				// Test if start_time is repeated twice
				// !== will also test for undefined cases, i.e. 4 === undefined will be false
				if (course.start_times[i] !== course.start_times[i + 1] || course.end_times[i] !== course.end_times[i + 1]) {
					// Takes in input time of 08:00 and call Utils.formatTime to return human readable time for start time
					timeString = this.formatTime(course.start_times[i]);
					// Hyphen to separate start_time and end_time
					timeString += " - ";
					// Takes in input time of 08:00 and call Utils.formatTime to return human readable time for end time
					timeString += this.formatTime(course.end_times[i]);

					// Finally, append the complete string to placeholder array (times)
					times.push(daysString + " " + timeString);
					// Re-initialize dayString for the next iterative loop
					daysString = "";
				}

			}

			// Finally, return the array of time pairs
			return times;
		},

		// Transforms "08:00" to 8:00AM and "13:45" to 1:45PM
		formatTime: function(time) {
			// Split incoming argument by colon, so "08:00" becomes ["08", "00"]
			var timeArray = time.split(":"),
				// Grab the first element (hour) and parse into int
				// Second argument (10) specifies what base we are in
				hour = parseInt(timeArray[0], 10);

			// Less than 12 hours, we are in the morning
			if (hour < 12) {
				// Can return original time, plus AM
				// LOOKAT
				// Actually, this is a little weird - don't know how it turns 08:00 to 08:00AM or 8:00AM
				return hour + ":" + timeArray[1] + "AM";
			} else if (hour == 12) {
				// If noon, then again like previous case just append PM to original string
				return time + "PM";
			} else {
				// Subtract twelve from hour, re-append minutes to it, then "PM"
				return hour - 12 + ":" + timeArray[1] + "PM";
			}
		}
	}

	// searchResults is a DIRECT representation of courses (and selected sections) below the search box
	// searchResults is an OBJECT with the course_id as key to selected sections
	// selected sections are further broken down by lectures, discussions, and laboratories, which are arrays of section ids
	// selected flag asks if this course is selected to be included in schedule generation
	// sample representation of searchResults is as follows:
	// searchResults = {
	// 	20382: {
	// 		selected: false,
	// 		units: 3
	// 		lectures: [203955, 30291, 203432],
	// 		discussions: [20392, 20395],
	// 		laboratories: []
	// 	}
	// }
	// In the above example, 20382 is course_id, and the arrays show SELECTED (or checked) sections that the user wants to generate schedules for
	// ANY logic changes to courses (selected sections, removing a course) MUST update this object!!
	var searchResults = {},

		// calendarCourses is a DIRECT representation of CALENDAR events
		// Clearing, adding, events must use this array of fullCalendar events!
		calendarCourses = [],
		savedSchedules = [],
		// schedules stores an array of potential schedules, which themselves are just an array of section objects
		schedules = [];

	// The div with the id=schedule is the container for the fullCalendar plugin
	// We initialize the plugin here, passing an object with option params
	// Documentation for these options are found in fullCalendar docs online
	$('#schedule').fullCalendar({
		// Default view for the calendar is agendaWeek, which shows a single week
		defaultView: 'agendaWeek',
		// No weekends for this view
		weekends: false,
		// Earliest time to be shown on the calendar is 8AM
		minTime: "08:00:00",
		// Latest time to be shown on the calendar is 10PM
		maxTime: "22:00:00",
		// Remove the box for showing potential all day events
		allDaySlot: false,
		columnFormat: {
			agendaWeek: 'dddd'
		},
		titleFormat: {
			agendaWeek: 'yyyy'
		},
		// Sets height of the plugin calendar
		contentHeight: 610,
		// Initialize the calendar with this set of events (should be empty anyway)
		events: calendarCourses,
		// New default date
		defaultDate: '2014-4-14'
	});

	// Bind a listener to the class-search textbox to listen for the enter key to start a search
	// Specifically, attach an anonymous function to the keyup event thrown by the class-search textbox
	$('#class-search').keyup(function(key) {
		// Anonymous function gets passed in the keyCode of the pressed key, 13 is the Enter key
		if (key.keyCode == 13) {
			// Call internal function courseSearch with the search phrase passed in by the textbox
			courseSearch($(this).val());
		}
	});

	// Alternatively, users can also "search" by selecting a prior saved course
	// Attaches an anonymous function to the change event thrown by the saved-courses combobox
	$('#saved-courses').change(function() {
		// For the selected option, trim any whitespace or newline around its text
		var course = $.trim($('#saved-courses option:selected').text());
		// Ignore the placeholder option at the very top
		if (course !== '-- Select Course --') {
			// Call internal function courseSearch with the search phrase associated with the selected option
			courseSearch(course);
		}
	});

	$('#generate-schedules').click(function() {
		if ($('#credits').text().split(" / ")[0] > 25) {
			alert("Too many credits selected!");
		} else {
			searchSchedules();
		}
	});

	// #save-selection exists in the Course - section selection modal
	// Upon hitting "save" when selecting sections for a course, update searchResults (internal representation of selected sections)
	$('#save-selection').click(function() {
		// Initialize placeholder arrays for lectures, discussions, and laboratories
		var lecture_ids = [],
			discussion_ids = [],
			laboratory_ids = [];

		// For all checked elements under the lectures heading (checkbox is checked)
		$('.lectures').children(':checked').each(function(index, element) {
			// The name of the checkbox (HTML attribute) is the section_id
			lecture_ids.push(parseInt(element.name));
		});

		// For all checked elements under the discussions heading (checkbox is checked)
		$('.discussions').children(':checked').each(function(index, element) {
			// The name of the checkbox (HTML attribute) is the section_id
			discussion_ids.push(parseInt(element.name));
		});

		// For all checked elements under the laboratories heading (checkbox is checked)
		$('.laboratories').children(':checked').each(function(index, element) {
			// The name of the checkbox (HTML attribute) is the section_id
			laboratory_ids.push(parseInt(element.name));
		});

		// Set the corresponding key and value pairs for searchResults, the internal representation of selected sections
		searchResults[$('#course-title').attr('course_id')]['lectures'] = lecture_ids;

		// Set the corresponding key and value pairs for searchResults, the internal representation of selected sections
		searchResults[$('#course-title').attr('course_id')]['discussions'] = discussion_ids;

		// Set the corresponding key and value pairs for searchResults, the internal representation of selected sections
		searchResults[$('#course-title').attr('course_id')]['laboratories'] = laboratory_ids;

		// Hides the modal (closes it)
		$('#course-modal').modal('hide');
	});

	// Shows the save-schedule modal upon clicking the save-schedule button
	$('#save-schedule-dialog').click(function() {
		// Grab the current selected schedule based on the slider's current value
		var schedule = schedules[$('#schedule-slider').slider('value')];
		// Only allow saving schedule if a schedule is on the calendar
		if (schedule) {
			// Select the (hidden) element save-schedule-modal and shows it with modal
			$('#save-schedule-modal').modal();
			// Autofill with name
			$('#name').val(schedule['name']);
		}
	});

	$('#name').keyup(function(key) {
		// Anonymous function gets passed in the keyCode of the pressed key, 13 is the Enter key
		if (key.keyCode == 13) {
			$('#save-schedule').click();
		}
	});

	// Upon hitting save-schedule in the save-schedule-modal, POST to the server the currently selected schedule and save it
	$('#save-schedule').click(function() {
		// Grab the current selected schedule based on the slider's current value
		var schedule = schedules[$('#schedule-slider').slider('value')];
		// If such a schedule exists (aka there's a schedule on the calendar)
		if (schedule) {
			// Turns the array of section objects into just an array of section_ids
			var section_ids = $.map(schedule['sections'], function(section) {
				// Each section object has a property (section_id) with the ids
				return section['section_id'];
			});

			// POST to the server the save result (create schedule)
			$.ajax('scheduler/schedules', {
				// POST for database change events
				method: 'POST',
				// Pass in desired params
				data: {
					// The name of the schedule (textbox)
					name: $('#name').val(),
					// JSON encoded array of selected section_ids
					sections: JSON.stringify(section_ids)
				},
				// If server didn't complain (no 404, 500 error, etc)
				success: function() {
					schedule['name'] = $('#name').val();
					$('#schedule-name').text(schedule['name']);

					// Simple alert, can be customized later
					alert("Schedule saved!");
					$('#save-schedule-modal').modal('hide');
				},
				// If server complains
				failure: function() {
					// Simple alert, can be customized later
					alert("Could not save schedule!");
				}
			});
		}
	});

	// Attach listener to the load-schedule button
	$('#load-schedules').click(function() {
		// Ask server for a list of saved schedules for that user and populate the modal with them
		// LOOKAT
		// Needs Modal, populating the modal, and function to relace schedules array with the loaded array of selected schedules from server
		$.ajax('scheduler/schedules', {
			success: function(response) {
				$('.schedules').empty();
				$.each(response['results'], function(index, schedule) {
					$('.schedules').append('<input type="checkbox" ' + false + ' name="' + schedule.id + '"> ' + schedule.name);

					if (index != response['results'].length - 1) {
						$('.schedules').append("<br/>");
					}
				});

				savedSchedules = response['results'];
				if (response['results'].length > 0) {
					$('#load-schedules-modal').modal();	
				} else {
					alert('No saved schedules!');
				}
			}
		});
	});

	$('#load-selected-schedules').click(function() {
		var selectedScheduleIds = $('.schedules').children(':checked').map(function(index, checkbox) {
				return parseInt(checkbox.name);
			}),
			selectedSchedules = $.grep(savedSchedules, function(schedule) {
				return selectedScheduleIds.index(schedule.id) != -1;
			});

		schedules = selectedSchedules;
		if (schedules.length > 0) {
			$('#schedule-slider').slider('option', 'max', schedules.length - 1);
			$('#load-schedules-modal').modal('hide');
			setSliderTicks();
		} else {
			$('#schedule-slider').slider('option', 'max', 0);
			alert('No selected schedules!');
		}
		$('#schedule-slider').slider('option', 'value', 0);
		loadSchedule(schedules[$('#schedule-slider').slider('value')]);
	});

	$('#clear-schedules').click(function() {
		$.ajax('scheduler/schedules', {
			method: 'DELETE',
			success: function() {
				savedSchedules = [];
				alert('Saved schedules cleared!');
			}
		});
	});

	$('#schedule-slider').slider({
		step: 1,
		min: 0,
		value: 0,
		animate: 'fast',

		slide: function(event, ui) {
			loadSchedule(schedules[ui.value]);
		}
	});

	function setSliderTicks() {
    	var $slider =  $('#schedule-slider');
    	var maxTick =  $slider.slider("option", "max");
    	var spacing =  100 / (maxTick);

    	$slider.find('.ui-slider-tick-mark').remove();
    	if(maxTick+1 < 30) {
    		for (var i = 0; i < maxTick+1 ; i++) {
        		$('<span class="ui-slider-tick-mark"></span>').css('left', (spacing * i) +  '%').appendTo($slider); 
     		}
     	}
     	else {
     		if((maxTick+1)/5 < 25) {
     			var remainder = (maxTick+1)%5;
     			for (var i = 0; i < maxTick+1-5; i+=5) {
        				$('<span class="ui-slider-tick-mark"></span>').css('left', (spacing * i) +  '%').appendTo($slider); 
     			}
     			if(remainder != 0)
     				$('<span class="ui-slider-tick-mark"></span>').css('left', (spacing * maxTick) +  '%').appendTo($slider); 
     		}
     		else {
     			var remainder = (maxTick+1)%10;
     			for (var i = 0; i < maxTick+1-10; i+=10) {
        				$('<span class="ui-slider-tick-mark"></span>').css('left', (spacing * i) +  '%').appendTo($slider); 
     			}
     			if(remainder != 0)
     				$('<span class="ui-slider-tick-mark"></span>').css('left', (spacing * maxTick) +  '%').appendTo($slider); 
     		}
     	}
	}

	// Asks server for course information + sections based on search string
	function courseSearch(course) {
		// If text was empty, implies that user wants to clear all courses
		if (course === '') {
			// Updates internal representation, searchResults
			searchResults = {};
			// Clears HTML view
			resultBox.empty();
		} else {
			// Split the course search string (i.e. CS 2150) into two portions, mnemonic and course_number
			course = course.split(' ');
			$.ajax('scheduler/search_course', {
				// mnemonic - "CS"
				// course_number - "2150"
				data: {
					mnemonic: course[0],
					course_number: course[1]
				},
				success: function(response) {
					// Returned course object must have id (response.id is course.id)
					if (!searchResults[response.id]) {
						// Initialize this course in searchResults
						// See above for sample searchResults representation
						searchResults[response.id] = {
							'selected': true,
							'units': response.units,
							'lectures': [],
							'discussions': [],
							'laboratories': []
						};
						// Calls utility function for showing the course (HTML)
						displayResult(response);
					}
				},
				error: function(response) {
					alert("Improper search!");
				}
			});
		}
	}

	// Asks server for set of possible schedules based on list of section_ids to permute over
	function searchSchedules() {
		var sections = [];
		$.each(searchResults, function(course_id, data) {
			if (data['selected']) {
				if (data['lectures'].length > 0) {
					sections.push(data['lectures'])
				}
				if (data['discussions'].length > 0) {
					sections.push(data['discussions'])
				}
				if (data['laboratories'].length > 0) {
					sections.push(data['laboratories'])
				}
			}
		});
		$.ajax('scheduler/generate_schedules', {
			data: {
				course_sections: JSON.stringify(sections)
			},
			success: function(response) {
				schedules = response;
				if (schedules.length > 0) {
					$('#schedule-slider').slider('option', 'max', schedules.length - 1);
					setSliderTicks();
				} else {
					$('#schedule-slider').slider('option', 'max', 0);
					alert('No possible schedules!');
				}
				$('#schedule-slider').slider('option', 'value', 0);
				loadSchedule(schedules[$('#schedule-slider').slider('value')]);
			}
		});
	}

	function displayResult(result) {
		var resultBox = $('.course-result.hidden').clone().removeClass('hidden'),
			content = resultBox.children('#content'),
			checkbox = resultBox.children('#checkbox').children(':checkbox');

		content.children('.remove').text('x');
		content.children('.remove').css({
			"float": "right",
			"color": "white"
		});

		content.children('.remove').click(function() {
			delete searchResults[result.id];
			$(this).parent().parent().remove();
		});

		content.click(function(event) {
			$('#course-title').text(result.title);
			$('#course-title').attr('course_id', result.id);
			$('.lectures').empty();
			$('.discussions').empty();
			$('.laboratories').empty();

			//Updated way of restoring checks to checkboxes
			//matched against array from above

			if (result.lectures.length > 0) {
				$("#lecture-header").show();
				for (var i = 0; i < result.lectures.length; i++) {
					isChecked = "";
					if (sectionSelected(result.lectures[i].section_id, result.id, 'lectures')) {
						isChecked = "checked";
					}
					$('.lectures').append('<input type="checkbox" ' + isChecked + ' name="' + result.lectures[i].section_id + '"> ');

					// if (searchResults[result.id]['lectures'] && searchResults[result.id]['lectures'].indexOf(result.lectures[i].section_id) != -1) {
					// 	$('.lectures').append('<input type="checkbox" checked name="' + result.lectures[i].section_id + '"> ');
					// } else {
					// 	$('.lectures').append('<input type="checkbox" name="' + result.lectures[i].section_id + '"> ');
					// }

					$('.lectures').append(Utils.formatTimeStrings(result.lectures[i]));
					$('.lectures').append(", " + result.lectures[i].professor);
					if (i != result.lectures.length - 1) {
						$('.lectures').append("<br/>");
					}
				}
			}
			if (result.discussions.length > 0) {
				$("#discussion-header").show();
				for (var i = 0; i < result.discussions.length; i++) {
					isChecked = "";
					if (sectionSelected(result.discussions[i].section_id, result.id, 'discussions')) {
						isChecked = "checked";
					}
					$('.discussions').append('<input type="checkbox" ' + isChecked + ' name="' + result.discussions[i].section_id + '"> ');

					// if (searchResults[result.id]['discussions'] && searchResults[result.id]['discussions'].indexOf(result.discussions[i].section_id) != -1) {
					// 	$('.discussions').append('<input type="checkbox" checked name="' + result.discussions[i].section_id + '"> ');
					// } else {
					// 	$('.discussions').append('<input type="checkbox" name="' + result.discussions[i].section_id + '"> ');
					// }

					$('.discussions').append(Utils.formatTimeStrings(result.discussions[i]));
					$('.discussions').append(", " + result.discussions[i].professor);
					if (i != result.discussions.length - 1) {
						$('.discussions').append("<br/>");
					}
				}
			}
			if (result.laboratories.length > 0) {
				$("#laboratory-header").show();
				for (var i = 0; i < result.laboratories.length; i++) {
					isChecked = "";
					if (sectionSelected(result.laboratories[i].section_id, result.id, 'laboratories')) {
						isChecked = "checked";
					}
					$('.laboratories').append('<input type="checkbox" ' + isChecked + ' name="' + result.laboratories[i].section_id + '"> ');

					// if (searchResults[result.id]['laboratories'] && searchResults[result.id]['laboratories'].indexOf(result.laboratories[i].section_id) != -1) {
					// 	$('.laboratories').append('<input type="checkbox" checked name="' + result.laboratories[i].section_id + '"> ');
					// } else {
					// 	$('.laboratories').append('<input type="checkbox" name="' + result.laboratories[i].section_id + '"> ');
					// }
					$('.laboratories').append(Utils.formatTimeStrings(result.laboratories[i]));
					$('.laboratories').append(", " + result.laboratories[i].professor);
					if (i != result.laboratories.length - 1) {
						$('.laboratories').append("<br/>");
					}
				}
			}
			$('#course-modal').modal();
		});

		content.children('.course-mnemonic').text(result.course_mnemonic);
		content.children('.course-title').text(result.title);

		checkbox.attr('name', result.id);
		checkbox.attr('checked', true);
		checkbox.change(function() {
			searchResults[parseInt(result.id)]['selected'] = $(this).prop('checked');

			var total = 0;
			$.each(searchResults, function(course_id, data) {
				if (data['selected']) {
					total += data['units'];
				}
			});
			$('#credits').text(total + " / 25");
		});
		checkbox.change();
		$('#results-box').append(resultBox);
		content.click();
	}

	function addClass(course) {
		var dateString;
		if (course.events.length == 0) {
			for (var i = 0; i < course.days.length; i++) {
				dateString = Utils.formatDateString(course.days[i])
				var event = {
					start: dateString + ' ' + course.start_times[i],
					end: dateString + ' ' + course.end_times[i],
				};
				event.__proto__ = course;
				course.events.push(event);
				calendarCourses.push(event);
			}
		} else {
			for (var i = 0; i < course.events.length; i++) {
				calendarCourses.push(course.events[i]);
			}
		}

		$('#schedule').fullCalendar('removeEvents');
		$('#schedule').fullCalendar('addEventSource', $.merge([], calendarCourses));
	}

	function loadSchedule(schedule) {
		calendarCourses = [];
		$('#schedule').fullCalendar('removeEvents');
		var name = 'Schedule Name';
		if (schedule) {
			name = schedule['name'];
			for (var i = 0; i < schedule['sections'].length; i++) {
				addClass(schedule['sections'][i]);
			}
		}
		$('#schedule-name').text(name);
	}

	// checks if  section has been saved so that it can be marked as checked
	function sectionSelected(section_id, course_id, type) {
		return searchResults[course_id][type].indexOf(section_id) != -1;
	}

});