#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

PATH_TO_HSS_MNEMONICS = ""
PATH_TO_HSS_EXCEPTIONS = ""
PATH_TO_HSS_ELECTIVES = ""

HSS_SUBDEPARTMENTS = File.read(PATH_TO_HSS_MNEMONICS).split(',').map(&:strip)
HSS_EXCEPTIONS = File.read(PATH_TO_HSS_EXCEPTIONS).split(',').map(&:strip)

f = File.new(PATH_TO_HSS_ELECTIVES, 'w')
f << "hss = MajorRequirement.create(:category => \"HSS Elective\")\n"
f << "hss.courses = Course.find_by_mnemonic_number([\n"
Course.all.each do |c|
  if (c.subdepartment && c.course_number)
    if (HSS_SUBDEPARTMENTS.include?(c.subdepartment.mnemonic) && 
          !HSS_EXCEPTIONS.include?(c.mnemonic_number))
      f << "\'#{c.mnemonic_number}\', "
    end
  end
end
f << "])"