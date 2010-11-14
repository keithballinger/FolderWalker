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
	
	# init function takes a folder walker
	def initialize(folder_walker)
		@folder_walker = folder_walker
	end
	
	# print_file_sizes prints all the files in the folder
	# tree in either a console friendly format or as CSV
	def print_file_sizes(format = Format::Normal, sortStyle = SortStyle::Size, minimumSize = 0)
		sorted_list = @folder_walker.get_files(sortStyle)
		print_sorted_list(sorted_list, format, minimumSize)
	end
	
	# print_folder_sizes prints all the subfolders in the folder
	# tree in either a console friendly format or as CSV
	def print_folder_sizes(format = Format::Normal, sortStyle = SortStyle::Size, minimumSize = 0)
		sorted_list = @folder_walker.get_folders(sortStyle)
		print_sorted_list(sorted_list, format, minimumSize)
	end
	
	def print_sorted_list(sorted_list, format = Format::Normal, minimumSize = 0)
		if format.eql?(Format::Normal)
			sorted_list.each do |key, value| 
				if value > minimumSize
					puts "#{key} size is #{commify(value)}" 
				end
			end
		else
			sorted_list.each do |key, value| 
				if value > minimumSize
					puts "#{key}\t#{commify(value)}" 
				end
			end
		end
	end
	
	# print_tree_size writes out the total size of the tree
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
