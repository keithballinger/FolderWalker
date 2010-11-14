# FolderWalker walks folders and calculates
# file and folder size.
#
# Author::    Keith Ballinger  (mailto:keith@gmail.com)
# Copyright:: Copyright (c) 2010 Keith Ballinger
# License::   Distributes under the same terms as Ruby

require 'find'

# Format class is used as an enum to specify
# how the printing detail should be displayed
# on the command-line.
class Format
	Normal=1
	CSV=2
end

# SortStyle class is used as an enum to specify
# how to sort files and folders when returned 
# from a function or when printed
class SortStyle
	Name=1
	Size=2
end

# FolderWalker class calculates folder and file size.
class FolderWalker
	
	attr_reader :total_size, :files, :sub_folders, :folder
	
	# init function takes a root folder name
	# default is current directory
	def initialize(folder = "./")
		@files = Hash.new
		@sub_folders = Hash.new
		@folder = folder
	end
	
	# run starts the folder walking and size calculations
	# for the root folder
	def run
		walk_tree(@folder)
		@total_size = calculate_tree_size(@folder)
		@sub_folders.each do |key, value|
				@sub_folders[key] = calculate_tree_size(key)
		end
	end
	
	# walk_tree is used to recursively walk the folder tree
	def walk_tree(folder = @folder)
		Find.find(folder) do |f|
			if File.file?(f)
				begin
					size = Integer(File.size?(f))
					@files[f] = size
				rescue TypeError
				end
			elsif folder.eql?(f)
				#the current folder shows up in this list - so skip it
			elsif File.directory?(f)
				@sub_folders[f] = 0
				walk_tree(f)
			end	
		end
	end
	
	# calculate_tree_size calculates the size for a particular sub folder
	def calculate_tree_size(folder = "./")
		total_size = 0
		@files.each do |name, size|
			begin
				if name.include? folder
					local_size = Integer(size)
					total_size = total_size + local_size
				end
			rescue TypeError
			end
		end
		return total_size
	end
	
	# get_files returns the files in the folders and sub folders.
	# Default sort is by size, but can also be sorted alpha by 
	# complete path name of file.
	def get_files(sort_style = SortStyle::Size)
		if sort_style.eql?(SortStyle::Name)
			return @files.sort
	else
			return @files.sort {|a,b| a[1]<=>b[1]}
		end
	end
	
	# get_folders returns the folders and sub folders.
	# Default sort is by size, but can also be sorted alpha by 
	# complete path name of folder.
	def get_folders(sort_style = SortStyle::Size)
		if sort_style.eql?(SortStyle::Name)
			return @sub_folders.sort
		else
			return @sub_folders.sort {|a,b| a[1]<=>b[1]}
		end
	end
	
	def print_files(format = Format::Normal)
		sort_files = get_files(SortStyle::Name)
		sort_files.each { |key, value| puts "#{key} size is #{value}" }
	end
	
	def print_file_sizes(format = Format::Normal)
		sort_files = get_files
		if format.eql?(Format::Normal)
			sort_files.each { |key, value| puts "#{key} size is #{commify(value)}" }
		else
			sort_files.each { |key, value| puts "#{key}\t#{commify(value)}" }
		end
	end
	
	def print_folder_sizes(format = Format::Normal)
		sort_folders = get_folders
		if format.eql?(Format::Normal)
			sort_folders.each { |key, value| puts "#{key} size is #{commify(value)}" }
		else
			sort_folders.each { |key, value| puts "#{key}\t#{commify(value)}" }
		end
	end
	
	def print_tree_size(folder = "./")
		puts "Total size for #{folder} is #{commify(@total_size)}"
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

if __FILE__ == $0
	f = FolderWalker.new("C:/Users/keith/Downloads")
	f.run
	f.print_tree_size("C:/Users/keith/Downloads/")
	f.print_file_sizes
	f.print_folder_sizes
end
