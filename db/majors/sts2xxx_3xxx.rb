sts2xxx_3xxx = MajorRequirement.create(:category => "STS 2xxx and 3xxx")
sts2xxx_3xxx.courses = Course.find_by_mnemonic_number(['STS 2070', 'STS 2071', 'STS 2140', 'STS 2160', 'STS 2201', 'STS 2500', 'STS 2620', 'STS 2760', 'STS 2810', 'STS 2850', 'STS 2840', 'STS 2993', 'STS 3020', 'STS 3110', 'STS 3500', 'STS 3520', 'STS 3993'])
