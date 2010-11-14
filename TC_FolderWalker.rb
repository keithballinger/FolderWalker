require "./FolderWalker"
require "test/unit"

class TC_FolderWalker < Test::Unit::TestCase
  
	# Simple test testing that folder property is correctly set
	def test_initialize
		assert_equal("./TestFolders/",FolderWalker.new("./TestFolders/").folder)
	end
 
	# Test that run finds the correct number of files
	def test_run_num_files
		f = FolderWalker.new("./TestFolders/")
		f.run
		assert_equal(6,f.files.length)
	end
  
	# Test that run finds the correct number of folders
	def test_run_num_folders
		f = FolderWalker.new("./TestFolders/")
		f.run
		assert_equal(6,f.sub_folders.length) #note that there are 6 sub folders
	end
 
	# Test that zero size folders are correctly calculated
	def test_calculate_tree_size_no_files
		f = FolderWalker.new("./TestFolders/")
		f.run
		assert_equal(0,f.calculate_tree_size("./TestFolders/Folder2/"))
	end
 
	# Test that calculation for size with one file are correct
	def test_calculate_tree_size_one_file
		f = FolderWalker.new("./TestFolders/")
		f.run
		assert_equal(391,f.calculate_tree_size("./TestFolders/Folder3/"))
	end
	
	# Test that calculation for size with manys files (including sub-folders) are correct
	def test_calculate_tree_size_many_files
		f = FolderWalker.new("./TestFolders/")
		f.run
		assert_equal(2705,f.calculate_tree_size("./TestFolders/Folder1/"))
	end
 end
