general_engr = MajorRequirement.create(:category => "SEAS Required Courses")
general_engr.courses = Course.find_by_mnemonic_number([ 'APMA 1110', 'APMA 2120', 'CHEM 1610', 'CHEM 1611', 'ENGR 1620', 'ENGR 1621', 'PHYS 1425', 'PHYS 1429', 'PHYS 2415', 'PHYS 2419' ])
