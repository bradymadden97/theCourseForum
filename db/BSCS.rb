bscs = Major.create(:name => 'Computer Science', :specialization => 'Bachelor of Science')
core = MajorRequirement.create(
	:major_id => bscs.id,
	:category => 'Core',
	:percentage_required => 100
)

core.courses = Course.find_by_mnemonic_numbers([
	'CS 1110',
	'CS 2110',
	'CS 2102',
	'CS 2150',
	'CS 2190',
	'CS 3102',
	'CS 3330',
	'CS 3240',
	'CS 4414',
	'CS 4102',
	'APMA 3100'
])

digital_logic = MajorRequirement.create(
	:major_id => bscs.id,
	:category => 'Digital Logic Design',
	:percentage_required => 50
)

digital_logic.courses = Course.find_by_mnemonic_numbers([
	'CS 2330',
	'ECE 2330'
])

capstone = MajorRequirement.create(
	:major_id => bscs.id,
	:category => 'Capstone',
	:percentage_required => 50
)

capstone.courses = Course.find_by_mnemonic_numbers([
	'CS 4971',
	'CS 4980'
])

apma = MajorRequirement.create(
	:major_id => bscs.id,
	:category => 'APMA',
	:percentage_required => 66
)

apma.courses = Course.find_by_mnemonic_numbers([
	'APMA 2130',
	'APMA 3080',
	'APMA 3120'
])