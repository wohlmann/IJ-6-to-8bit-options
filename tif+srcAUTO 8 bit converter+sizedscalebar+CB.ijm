//getting file and Dir List:
dir1 = getDirectory("Choose source directory ");		//request source dir via window
list = getFileList(dir1);								//read file list
dir2 = getDirectory("Choose destination directory ");		//request destination dir via window
waitForUser("Number of files","convert "+list.length+" files?\nPress Esc to abort");	//check if correct number of files
//counter for report
N=0;														//set # of converted images=0
//get user details about scalebar and CB
	Dialog.create("scalebar");
	Dialog.addMessage("choose options");
	Dialog.addCheckbox("add scalebar", true);
	Dialog.addNumber("scalebar height [px] =", 8);
	Dialog.addCheckbox("show lettering", true);
	Dialog.addNumber("scalebar Font [px] =", 28)
	Dialog.addCheckbox("auto enhance contast", false);
	Dialog.addNumber("saturated =", 0.30);
	Dialog.addCheckbox("manual enhance contast", false);
	Dialog.show();
	scale = Dialog.getCheckbox();							//add scalebar option
	scHeight = Dialog.getNumber();							//height of scalebar itself in px
	SL = Dialog.getCheckbox();								//add scalebar lettering option
	scFont = Dialog.getNumber();							//Fontsize of scalebar lettering in px
	AEC = Dialog.getCheckbox();								//use auto contrast brightness
	sat = Dialog.getNumber();								//saturation factor for ACB
	MEC = Dialog.getCheckbox();								//use manual contrast brightness for each image
	if (SL != true){										//hide scalebar lettering
		scalelabel = "hide";}
	else{scalelabel = "";}
	if (scale == true){										//to avoid double filenames
		scalename = "_s";}
	else{scalename = "";}
//start loop:
	for (i=0; i<list.length; i++) {							//set i=0, count nuber of list items, enlagre number +1 each cycle, start cycle at brackets
		path = dir1+list[i];								//path location translated for code
		//waitForUser("next file="," "+path+"");
//get filetype (could be extended)
		SER = (endsWith(path, "ser"));						//variable yto enter relevant process for *.ser
		TIF = (endsWith(path, "tif"));						//variable yto enter relevant process for *.tif
		if (TIF == true){
		//if (endsWith(path, "tif")){
			open(path);
			title = getTitle;								//get title of actual image
			title2 = File.nameWithoutExtension;				//get title of actual image
				//run("Clear Results");						//to start with an empty results table
				//updateResults;
			getVoxelSize(Vwidth, Vheight, Vdepth, Vunit);
//add scalebar depending on magnification and user selected adaptions
			if (scale == true && Vwidth <=0.001){
					SCwidth=200;							// with of bar itself in unit (heigth of bar could be adjusted using a aditional variable
					SCunit="nm";							// unit
					SCknown=1000;}							// adjusts  m in nm
			if (scale == true && Vwidth >=0.001 && Vwidth <=0.003){
					SCwidth=500;
					SCunit="nm";
					SCknown=1000;}
			if (scale == true && Vwidth >=0.003 && Vwidth <=0.006){
					SCwidth=1;
					SCunit="µm";
					SCknown=1;}
			if (scale == true && Vwidth >=0.006 && Vwidth <=0.03){
					SCwidth=2;
					SCunit="µm";
					SCknown=1;}
			if (scale == true && Vwidth >=0.03){
					SCwidth=10;
					SCunit="µm";
					SCknown=1;}
			if (AEC == true){
				selectWindow(""+title+"");
				run("Enhance Contrast", "saturated="+sat+"");}		// ACB
			if (MEC == true){
				selectWindow(""+title+"");
				run("Brightness/Contrast...");
				waitForUser("User Adjustments", "Please adjust image to your needs \n (e.g. contrast and brightness) \n and click OK if done");
			}
			if (scale == true){								// prints scalebar if chosen
				selectWindow(""+title+"");
				run("Set Scale...", "known="+SCknown+" unit="+SCunit+""); //adjust to nm if necessary
				run("Scale Bar...", "width="+SCwidth+" height="+scHeight+" font="+scFont+" color=Black background=None location=[Lower Right] bold "+scalelabel+" overlay");
				run("Flatten", "stack");}							//flatten to burn in overlays for tiff (can be switched of for layered formats)
//8 bit conversion
			if (scale == true){
				selectWindow(""+title2+"-1.tif");}			// as flatening generates a new image
			else{
				selectWindow(""+title2+".tif");				// if no flattening was used
			}
			run("8-bit");									// 8bit
			saveAs("Tiff", dir2+title2+scalename+"_8b.tif");
//close all windows to clean up for next round
			if (isOpen("B&C")) {
				selectWindow("B&C");
				run("Close");
		    }
			{
			while (nImages>0) {									// close remains
				selectImage(nImages);
				close(); } }
			N=N+1;
//			TIF == false;										// reset variable
			}
		if (SER == true){
		//if (endsWith(path, "ser")){
			run("TIA Reader", ".ser-reader...=["+path+"]");		//import files via TIA reader ( plugin needs to be installed)
			dir = getDirectory("image");
			title = getTitle;									//get title of actual image
			title2 = File.nameWithoutExtension;					//get title of actual image
					//run("Clear Results");							//to start with an empty results table
					//updateResults;
			getVoxelSize(Vwidth, Vheight, Vdepth, Vunit);		//get voxel size to adapt scalebar
			//add scalebar depending on magnification (Dialoque with options as variables can be done before loop)
			if (scale == true && Vwidth <=0.001){
					SCwidth=200;								// with of bar itself in unit (heigth of bar could be adjusted using a aditional variable
					SCunit="nm";								// unit
					SCknown=1000;}								// adjusts  m in nm
			if (scale == true && Vwidth >=0.001 && Vwidth <=0.003){
					SCwidth=500;
					SCunit="nm";
					SCknown=1000;}
			if (scale == true && Vwidth >=0.003 && Vwidth <=0.006){
					SCwidth=1;
					SCunit="µm";
					SCknown=1;}
			if (scale == true && Vwidth >=0.006 && Vwidth <=0.03){
					SCwidth=2;
					SCunit="µm";
					SCknown=1;}
			if (scale == true && Vwidth >=0.03){
					SCwidth=10;
					SCunit="µm";
					SCknown=1;}
			if (AEC == true){
				selectWindow(""+title+"");
				run("Enhance Contrast", "saturated="+sat+"");}		// ACB
			if (MEC == true){
				selectWindow(""+title+"");
				run("Brightness/Contrast...");
				waitForUser("User Adjustments", "Please adjust image to your needs \n (e.g. contrast and brightness) \n and click OK if done");
			}
			if (scale == true){									// prints scalebar if chosen
				selectWindow(""+title+"");
				run("Set Scale...", "known="+SCknown+" unit="+SCunit+""); //adjust to nm if necessary
				run("Scale Bar...", "width="+SCwidth+" height="+scHeight+" font="+scFont+" color=Black background=None location=[Lower Right] bold "+scalelabel+" overlay");
				run("Flatten", "stack");}							//flatten to burn in overlays for tiff (can be switched of for layered formats)
				title3 = getTitle;
			//conversion
			if (scale == true){
				selectWindow(""+title3+"");}					// as flatening generates a new image
			else{
				selectWindow(""+title+"");}						// if no flattening was used
				//run("Apply LUT");
			run("8-bit");										// 8bit
			saveAs("Tiff", dir2+title2+scalename+"_8b.tif");
			//close all windows to clean up for next round
			if (isOpen("B&C")) {
				selectWindow("B&C");
				run("Close");
		    }
			while (nImages>0) {									// close remains
				selectImage(nImages);
				close(); }
			N=N+1;												//counter for report
			//SER == false;										// reset variable
			}
}
	//report
	waitForUser("Summary"," "+N+" files processed");
exit();
//Jens_19_04_2018