#Demo
will_it_sink_driver <- function(indirectory="./data/aus_gbr/", outdirectory="./data/aus_gbr_out/") {
  
  file_list <-  list.files(indirectory)
  
  for (file in file_list) {
    #Pull together filepath
    filepath <- paste(indirectory,"/",file,sep="")
    outfilepath <- paste(outdirectory,"/","wis_",file,sep="")
    
    #Verify the file exists before we continue
    if(file.exists(filepath)) {
      message (cat("File", filepath , "exists, starting process "))
      will_it_sink(sample_file_path=filepath, out_file_path=outfilepath)
      message (cat("File", outfilepath , "created "))
    }
    else {
      message (cat("File", filepath , "does not exist"))
    }
  }
}