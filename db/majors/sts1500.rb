sts = MajorRequirement.create(:category => "STS")
sts.courses = Course.find_by_mnemonic_number([''])
