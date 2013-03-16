# Downloads and imports all charities from the IRS website.
# Must specify download URL since there is a possibility
# that it may change in the future.

require 'open-uri'
require 'zip/zip'
require 'fileutils'

def import_charities_from_irs(irs_charities_url)
	open(irs_charities_url) {|z|
		Zip::ZipFile.open(z.path) do |zf|
			# get the first file in the zipped file (only contains one)
			first_file = zf.first

			FileUtils.mkdir_p(File.dirname(first_file.to_s))

			# extract the file (overwrite if exists)
			file = zf.extract(first_file, first_file.to_s) { true }

			# read the file line by line
			File.readlines(file.to_s).each {|line|
				# split the current line into columns
				columns = line.gsub("\r\n", '').split('|').compact
				next if columns.empty?

				puts columns.inspect
				# columns[0] => EIN
				# columns[1] => Doing Business As
				# columns[2] => City
				# columns[3] => State
				# columns[4] => Country
				# columns[5] => Deductibility Status
			}
		end
	}
end


# call the import method with the download link
import_charities_from_irs('http://apps.irs.gov/pub/epostcard/data-download-pub78.zip')