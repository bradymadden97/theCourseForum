#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

PATH_TO_HSS_MNEMONICS = ""
PATH_TO_HSS_EXCEPTIONS = ""
PATH_TO_HSS_ELECTIVES = ""

HSS_SUBDEPARTMENTS = []
File.readlines(PATH_TO_HSS_MNEMONICS).map do |line|
  HSS_SUBDEPARTMENTS.push(line.to_s.strip.gsub(/[\s,]/ ,""))
end

HSS_EXCEPTIONS = []
File.readlines(PATH_TO_HSS_EXCEPTIONS).map do |line|
  HSS_EXCEPTIONS.push(line.to_s.strip.gsub(/[,]/ ,""))
end

f = File.new(PATH_TO_HSS_ELECTIVES, 'w')
f << "hss = MajorRequirement.create(:category => \"HSS Elective\")\n"
f << "hss.courses = Course.find_by_mnemonic_number([\n"
Course.all.each do |c|
  if (c.subdepartment && c.course_number)
    if (HSS_SUBDEPARTMENTS.include?(c.subdepartment.mnemonic) && 
          !HSS_EXCEPTIONS.include?(c.mnemonic_number))
      f << "\'#{c.mnemonic_number}\',"
      f << "\n"
    end
  end
end
f << "])"
