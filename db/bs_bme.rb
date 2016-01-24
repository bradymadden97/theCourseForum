bsbme = Major.create(
  :name => 'Biomedical Engineering', 
  :degree => 'B.S.'
)

# Required Courses

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

bme.courses = Course.find_by_mnemonic_numbers([
  'BME 4414',
  'BME 4641',
  'BME 4890',
  'BME 4550',
  'BME 4280',
  'BME 4417',
  'BME 4783',
  'BME 4806',
  'BME 4550',
  'BME 4995',
  'BME 4993'
])

# TODO: Courses fulfilled through Electives