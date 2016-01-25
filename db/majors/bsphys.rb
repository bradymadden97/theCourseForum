bsphys = Major.create(:name => 'Physics', :specialization => 'Bachelor of Science')

core = MajorRequirement.create(
	:major_id => bsphys.id,
	:category => 'Core',
	:credits_required => 
)

main_track = MajorRequirement.create(
	:major_id => bsphys.id,
	:category => 'Track 1',
	:credits => 
)