# Author::    Keith Ballinger  (mailto:keith@gmail.com)
# Copyright:: Copyright (c) 2010 Keith Ballinger
# License::   Distributes under the same terms as Ruby

require "./FolderWalker"

# Format class is used as an enum to specify
# how the printing detail should be displayed
# on the command-line.
class Format
	Normal=1
	CSV=2
end

# ConsoleReporter reports folder and file size to the console.
class Reporter
	
	attr_reader :folder_walker
	
	# init function takes a root folder name
	# default is current directory
	def initialize(folder_walker)
		@folder_walker = folder_walker
	end
	
	def print_files(format = Format::Normal)
		sort_files = @folder_walker.get_files(SortStyle::Name)
		sort_files.each { |key, value| puts "#{key} size is #{value}" }
	end
	
	def print_file_sizes(format = Format::Normal)
		sort_files = @folder_walker.get_files
		if format.eql?(Format::Normal)
			sort_files.each { |key, value| puts "#{key} size is #{commify(value)}" }
		else
			sort_files.each { |key, value| puts "#{key}\t#{commify(value)}" }
		end
	end
	
	def print_folder_sizes(format = Format::Normal)
		sort_folders = @folder_walker.get_folders
		if format.eql?(Format::Normal)
			sort_folders.each { |key, value| puts "#{key} size is #{commify(value)}" }
		else
			sort_folders.each { |key, value| puts "#{key}\t#{commify(value)}" }
		end
	end
	
	def print_tree_size()
		puts "Total size for #{@folder_walker.folder} is #{commify(@folder_walker.total_size)}"
	end
	 
	#
	# add commas to the numbers
	# From http://codesnippets.joyent.com/posts/show/330
	#
	def commify(number)
			c = { :value => "", :length => 0 }
			r = number.to_s.reverse.split("").inject(c) do |t, e|  
			iv, il = t[:value], t[:length]
			iv += ',' if il % 3 == 0 && il != 0    
			{ :value => iv + e, :length => il + 1 }
		end
		r[:value].reverse!
	end

end
