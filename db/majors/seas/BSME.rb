#!/usr/bin/env ruby
require_relative "./hss_electives"
require_relative "./unrestricted_electives"
require_relative "./general_engr"
require_relative "./science_elective"
require_relative "./sts15_45_4600"
require_relative "./sts2xxx_3xxx"

bsme = Major.create(
	:name => 'Mechanical Engineering', 
	:specialization => 'B.S.'
)

#Required Courses

core = MajorRequirement.create(
	:major_id => bsme.id,
	:category => 'Core',
	:credits_required => 47
)

core.courses = Course.find_by_mnemonic_number([
	'MAE 2000',
	'MAE 2300',
	'MAE 2100',
	'MAE 2310',
	'MAE 2320',
	'MAE 3210',
	'MAE 3310',
	'MAE 3710',
	'MAE 3810',
	'MAE 3140',
	'MAE 3620',
	'MAE 3840',
	'MAE 4710',
	'APMA 3110',
	'APMA 2130'
])



