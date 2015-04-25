bsbme = Major.create(:name => 'Biomedical Engineering', :specialization => 'Bachelor of Science')

core = MajorRequirement.create(
	:major_id => bsbme.id,
	:category => 'Core',
	:credits_required => 38
)

core.courses = Course.find_by_mnemonic_numbers([
	'BME 2000',
	'BME 2101',
	'BME 2102',
	'BME 2104',
	'BME 2220',
	'BME 2240',
	'BME 3310',
	'BME 3315',
	'BME 3080',
	'BME 3090',
	'BME 4063',
	'BME 4064'
])

bme = MajorRequirement.create(
	:major_id => bsbme.id,
	:category => 'BME Elective',
	:credits_required => 9
)