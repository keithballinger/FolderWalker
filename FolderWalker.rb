# FolderWalker walks folders and calculates
# file and folder size.
#
# Author::    Keith Ballinger  (mailto:keith@gmail.com)
# Copyright:: Copyright (c) 2010 Keith Ballinger
# License::   Distributes under the same terms as Ruby

require 'find'

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
	def calculate_tree_size(folder)
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

end
