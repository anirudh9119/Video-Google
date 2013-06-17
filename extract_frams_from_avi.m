filename = './movie.mp4';

mov = MMREADER(filename);


% Output folder
%b=5
outputFolder = fullfile(cd, '/media/Elements/test5/');
if ~exist(outputFolder, 'dir')
mkdir(outputFolder);
end
%c=5
%getting no of frames
%d=5
numberOfFrames = mov.NumberOfFrames;
numberOfFramesWritten = 0;
%j=8
%for frame = 1 : numberOfFrames
frame=1;	
while (frame < numberOfFrames) 
	thisFrame = read(mov, frame);
	outputBaseFileName = sprintf('%3.3d.jpg', frame);
	outputFullFileName = fullfile(outputFolder, outputBaseFileName);
	imwrite(thisFrame, outputFullFileName, 'jpg');
	progressIndication = sprintf('Wrote frame %4d of %d.', frame,numberOfFrames);
	disp(progressIndication);
	frame=frame+4;
	% for taking every ffth frame ..
	numberOfFramesWritten = numberOfFramesWritten + 1;
end
progressIndication = sprintf('Wrote %d frames to folder "%s"',numberOfFramesWritten, outputFolder);
disp(progressIndication);
exit;
