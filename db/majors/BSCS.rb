#!/usr/bin/env ruby
require_relative "./hss_electives"
require_relative "./unrestricted_electives"
require_relative "./general_engr"
require_relative "./science_elective"
require_relative "./sts15_45_4600"
require_relative "./sts2xxx_3xxx"

bscs = Major.create(
  :name => 'Computer Science', 
  :specialization => 'B.S.'
)

# Required Courses

core = MajorRequirement.create(
  :major_id => bscs.id,
  :category => 'Core',
  :credits_required => 31
)

core.courses = Course.find_by_mnemonic_number([
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
  :credits_required => 3
)

digital_logic.courses = Course.find_by_mnemonic_number([
  'CS 2330',
  'ECE 2330'
])

capstone = MajorRequirement.create(
  :major_id => bscs.id,
  :category => 'Capstone',
  :credits_required => 2
)

capstone.courses = Course.find_by_mnemonic_number([
  'CS 4971',
  'CS 4980'
])

apma = MajorRequirement.create(
  :major_id => bscs.id,
  :category => 'APMA',
  :credits_required => 6
)

apma.courses = Course.find_by_mnemonic_number([
  'APMA 2130',
  'APMA 3080',
  'APMA 3120'
])

# Elective Courses

hss = MajorRequirement.find_by(:category => "HSS Elective")
hss.major_id = bscs.id
hss.credits_required = 15

unrestricted = MajorRequirement.find_by(:category => "Unrestricted Elective")
unrestricted.major_id = bscs.id
unrestricted.credits_required = 15

general_engr = MajorRequirement.find_by(:category => "SEAS Required Courses")
general_engr.major_id = bscs.id
general_engr.credits_required = 24

science_elective = MajorRequirement.find_by(:category => "Science Elective")
science_elective.major_id = bscs.id
science_elective.credits_required = 3

sts15_45_4600 = MajorRequirement.find_by(:category => "STS 1500, 4500, 4600")
sts15_45_4600.major_id = bscs.id
sts15_45_4600.credits_required = 9

sts2xxx_3xxx = MajorRequirement.find_by(:category => "STS 2xxx and 3xxx")
sts2xxx_3xxx.major_id = bscs.id
sts2xxx_3xxx.credits_required = 3

