function [class] = searchImage(image,desc)

image='dataset/train/ans.jpg'              % Name of the image which to search for . IN our case , it will be rectangular portion which will be given by the user.
%For Web Interface, make trainDir='../dataset/train'
%Also, uncomment the last few lines. 
desc = 'sift';
%run('/home/anirudh/vlfeat/toolbox/vl_setup.m');
%trainDir='dataset/train';
trainDir ='dataset/';
load(fullfile(trainDir,'images.mat'));
load(fullfile(trainDir,'imageClass.mat'));
load(fullfile(trainDir,[desc,'-invertedIndex.mat']));
load(fullfile(trainDir,[desc,'-vocab.mat']));
load(fullfile(trainDir,[desc,'-model.mat']));
load(fullfile(trainDir,[desc,'-hist.mat']));
im = imread(image);
K=100;

numWords = size(vocab,2);
docVec=zeros(1,numWords);
switch desc
   case 'sift'
        if(size(im,3)>=3)
            im = single(rgb2gray(im)) ;
        else
            im=single(im);
        end
        [frames, descrs] = vl_sift(im) ;
      %  im=imread(image);
end

binsa = double(vl_kdtreequery(model,vocab,single(descrs))) ;
docVec=hist(binsa,numWords);
hists=cat(1,hists,docVec);
%--------------------------------------------- calculate doc vectors--------
wordFrequency=sum(hists~=0);
docVectors=zeros(size(hists));
idf=(log(size(hists,1)*1.0./(wordFrequency+1)));
for i=1:size(hists,1)
    numdocWords=sum(sum(hists(i,:)))+1;
    docVectors(i,:)=(hists(i,:)./numdocWords).*idf;
end
%---------------------------------------------------------------------search and score

scores=zeros(size(hists,1)-1,1);
    for dn=1:size(hists,1)-1
  scores(dn,1)=sum(sum(hists(dn,:).*hists(end,:)))/(sum(sum((hists(dn,:).^2)))^0.5*sum(sum(hists(end,:).^2))^0.5);
end

[score,docNum]=sort(scores,'descend');
docNum=docNum(1:K);
%subplot(K/2+1,2,[1,2]),imshow(im);
class=zeros(K);
K
for i=1:K
    images{docNum(i)} % . It gives the name of the images similar to the
    %previous ones.
    im=imread(strcat(trainDir,'/',images{docNum(i)}));
    %subplot(K/2+1,2,i+2);
    %imshow(im);
    class(i)=imageClass(docNum(i));
    imwrite(im,['results/',num2str(i),'.jpg'],'JPG');%%Uncomment for web
end
%saveas(gca,strcat('dataset',image(1:end-4),'_result.jpg'),'jpg');
close
end
