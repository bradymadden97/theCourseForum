sts15_45_4600 = MajorRequirement.create(:category => "STS 1500, 4500, 4600")
sts15_45_4600.courses = Course.find_by_mnemonic_number(['STS 1500', 'STS 4500', 'STS 4600'])
