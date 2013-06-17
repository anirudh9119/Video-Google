%%http://matlabnstuff.blogspot.in/2013/01/extracting-frames-from-video-file.html
%https://github.com/vlfeat/vlfeat/blob/master/apps/phow_caltech101.m
function BoW

%desc={'sift',   'surf','hog'};
desc= {'sift'};

% Stores all the information about a particular directory.
trainDir='dataset';
classes=dir(trainDir); % contains all the infomration about directory strucutre    
classes = classes([classes.isdir]);
classes = {classes(3:3).name}; %  Store the names of 3 -13 directories in classes

%numtrain=10;
%numtest=10;
images={};
imageClass={};
for i = 1:length(classes)
    im = dir(fullfile(trainDir,classes{i},'*.jpg'))';
%    im = vl_colsubset(im, numTrain + numTest) ;
    im = cellfun(@(x)fullfile(classes{i},x),{im.name},'UniformOutput',false);
    images = {images{:}, im{:}};
    imageClass{end+1} = i*ones(1,length(im));
end
length(images)
imageClass=cat(2,imageClass{:});
save(fullfile(trainDir,'imageClass.mat'), 'imageClass');
save(fullfile(trainDir,'images.mat'), 'images');

vocab={};
model={};

for i = 1:length(desc)
    desc{i}
    descriptor = [];
    if ~exist(fullfile(trainDir,[desc{i} '-vocab.mat']))   
        for ii = 1:length(images)
            %ii
            Img = imread(fullfile(trainDir,images{ii}));
            switch desc{i}
                case 'sift'
                    if(size(Img,3)>=3)
                        Img = single(rgb2gray(Img));
                    else
                        Img = single(Img);
                    end
                    [drop, descrs] = vl_sift(Img);
            end
         %   a=3
            clear Img;
          %  b=5 
           % size(descrs)    
            descriptor=[descriptor single(descrs)];
        end

        %descriptor
        %a=[2,3,4]
        vocab = vl_kmeans(descriptor, 200, 'verbose', 'algorithm', 'elkan');
        save(fullfile(trainDir,[desc{i} '-vocab.mat']), 'vocab');
        model=vl_kdtreebuild(vocab);    
        save(fullfile(trainDir,[desc{i} '-model.mat']), 'model');
    else
        load(fullfile(trainDir,[desc{i} '-vocab.mat']));
        load(fullfile(trainDir,[desc{i} '-model.mat']));
    end
    
    if ~exist(fullfile(trainDir,[desc{i} '-hist.mat']))
        hists={};
        numWords = size(vocab,2);
        for ii = 1:length(images)
            Img = imread(fullfile(trainDir,images{ii}));
            docVectors=zeros(1,numWords);
            switch desc{i}
                    case 'sift'
                        if(size(Img,3)>=3)
                            Img = single(rgb2gray(Img));
                        else
                            Img = single(Img);
                        end
                        [drop, descrs] = vl_sift(Img);
            end
            bins=double(vl_kdtreequery(model,vocab,single(descrs)));
            hists{ii}=hist(bins,numWords);
        end
        hists = cat(1,hists{:});
        save(fullfile(trainDir,[desc{i} '-hist.mat']),'hists');
        totalWords=sum(sum(hists));
        wordFrequency=sum(hists~=0);

        for word=1:size(hists,2)
            [wordfreq,docNum]=sort(hists(:,word)','descend');
            invertedIndex{word}={wordFrequency(1,word),docNum,wordfreq};
        end
        save(fullfile(trainDir,[desc{i} '-invertedIndex.mat']),'invertedIndex');
    end
end
end
exit;

