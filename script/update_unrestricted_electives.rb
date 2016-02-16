#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

PATH_TO_UNRESTRICTED_MNEMONICS = ""
PATH_TO_UNRESTRICTED_EXCEPTIONS = ""
PATH_TO_UNRESTRICTED_ELECTIVES = ""

UNRESTRICTED_SUBDEPARTMENTS = File.read(PATH_TO_UNRESTRICTED_MNEMONICS).split(',').map(&:strip)
UNRESTRICTED_EXCEPTIONS = File.read(PATH_TO_UNRESTRICTED_EXCEPTIONS).split(',').map(&:strip)

f = File.new(PATH_TO_UNRESTRICTED_ELECTIVES, 'w')
f << "unrestricted = MajorRequirement.create(:category => \"Unrestricted Elective\")\n"
f << "unrestricted.courses = Course.find_by_mnemonic_number([\n"
Course.all.each do |c|
  if (c.subdepartment && c.course_number)
    if (UNRESTRICTED_SUBDEPARTMENTS.include?(c.subdepartment.mnemonic) && 
          !UNRESTRICTED_EXCEPTIONS.include?(c.mnemonic_number))
      f << "\'#{c.mnemonic_number}\', "
    end
  end
end
f << "])"