# read in the file to clean
file_name = ARGV[0]
file = File.open(file_name)
file_contents = file.read
file_contents.downcase!
file_contents.gsub!(/[^a-z\s]/, '')
file_contents.gsub!(/[\r\n\t]/, ' ')
file_contents.gsub!(/\s{2,}/, ' ')
output_file = File.open('CLEAN_'+file_name, 'w')
output_file.write(file_contents)