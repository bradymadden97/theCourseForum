#!/usr/bin/env ruby
require_relative "./hss_electives"
require_relative "./unrestricted_electives"
require_relative "./general_engr"
require_relative "./science_elective"
require_relative "./sts15_45_4600"
require_relative "./sts2xxx_3xxx"

bscpe = Major.create(
  :name => "Computer Engineering",
  :specialization => "B.S."
)

# Required Courses

core = MajorRequirement.create(
  :major_id => bscpe.id,
  :category => "Core",
  :credits_required => 44.5
)

core.courses = Course.find_by_mnemonic_number([
  'CS 1110',
  'CS 2110',
  'CS 2102',
  'ECE 2630',
  'ECE 2660',
  'CS 2150',
  'ECE 3750',
  'ECE 3430',
  'CS 3240',
  'CS 4414',
  'ECE 4435',
  'ECE 4440',
])

digital_logic = MajorRequirement.create(
  :major_id => bscpe.id,
  :category => 'Digital Logic Design',
  :credits_required => 3
)

digital_logic.courses = Course.find_by_mnemonic_number([
  'CS 2330',
  'ECE 2330'
])

computer_networks = MajorRequirement.create(
  :major_id =>bscpe.id,
  :category => 'Computer Networks',
  :credits_required => 3
)

computer_networks.courses = Course.find_by_mnemonic_number([
  'CS 4457',
  'ECE 4457'
])

# Elective Courses

hss = MajorRequirement.find_by(:category => "HSS Elective")
hss.major_id = bscpe.id
hss.credits_required = 9

unrestricted = MajorRequirement.find_by(:category => "Unrestricted Elective")
unrestricted.major_id = bscpe.id
unrestricted.credits_required = 15

general_engr = MajorRequirement.find_by(:category => "SEAS Required Courses")
general_engr.major_id = bscpe.id
general_engr.credits_required = 24

science_elective = MajorRequirement.find_by(:category => "Science Elective")
science_elective.major_id = bscpe.id
science_elective.credits_required = 3

sts15_45_4600 = MajorRequirement.find_by(:category => "STS 1500, 4500, 4600")
sts15_45_4600.major_id = bscpe.id
sts15_45_4600.credits_required = 9

sts2xxx_3xxx = MajorRequirement.find_by(:category => "STS 2xxx and 3xxx")
sts2xxx_3xxx.major_id = bscpe.id
sts2xxx_3xxx.credits_required = 3 

