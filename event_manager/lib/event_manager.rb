# frozen_string_literal: true

require 'csv'
require 'erb'
require 'google-apis-civicinfo_v2'

# Functions --------------------------------------------------------------------

# @param zipcode [String]
# @return [String]
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

# @param phone [String]
# @return [String, nil]
def clean_phone(phone)
  phone = phone.gsub(/\D/, '')
  return phone if phone.length == 10
  return phone[1..] if phone.length == 11 && phone[0] == '1'

  nil
end

# @param zipcode [String]
def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  begin
    civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

# @param id [String]
# @param form_letter [String]
def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  filename = "output/thanks_#{id}.html"
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

# Main -------------------------------------------------------------------------

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.rhtml')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone = clean_phone(row[:homephone])
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)
  save_thank_you_letter(id, form_letter)
end
