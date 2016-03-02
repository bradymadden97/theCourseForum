science_elective = MajorRequirement.create(:category => "Science Elective")
science_elective.courses = Course.find_by_mnemonic_number(['BIOL 2010', 'BIOL 2020', 'CHEM 1620', 'ECE 2066', 'ENGR 2500', 'MSE 2090', 'PHYS 2620'])
