# Aerospace Engineering Curriculum for 2018 graduates
# Much overlap with Materials Science Engineering

bsae = Major.create(
	:name => 'Aerospace Engineering'
	:degree => 'B.S.'
)

# Required Courses

core = MajorRequirement.create(
	:major_id =>bsae.id,
	:category => 'Core',
	:credits_required => 49
)

core.courses = Course.find_by_mnemonic_numbers([
	'MAE 2010',
	'MAE 2300',
	'MAE 2310',
	'MAE 2100',
	'MAE 2320',
	'MAE 3210',
	'MAE 3310',
	'MAE 3610',
	'MAE 3810',
	'MAE 3010',
	'MAE 3220',
	'MAE 3820',
	'MAE 3730',
	'MAE 4650',
	'MAE 4120',
	'MAE 4660'
])

