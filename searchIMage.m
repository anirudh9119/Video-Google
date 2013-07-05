function searchImage(image,desc)

image='../IMAGES/ans.jpg'              % Name of the image which to search for . IN our case , it will be rectangular portion which will be given by the user.
%For Web Interface, make trainDir='../dataset/train'
%Also, uncomment the last few lines. 
desc = 'sift';
run('./vlfeat-0.9.16/toolbox/vl_setup.m');
%trainDir='dataset/train';
%trainDir ='./Charade1/';
%load(fullfile(trainDir,'images.mat'));
%load(fullfile(trainDir,'imageClass.mat'));
%load(fullfile(trainDir,[desc,'-invertedIndex.mat']));
%load(fullfile(trainDir,[desc,'-inverted.mat']));
%load(fullfile(trainDir,[desc,'-tree.mat']));
%load('./Charade1/sift-hist.mat');
%load(fullfile(trainDir,[desc,'-hist.mat']));
%load(fullfile('./Charade1',[['sift-hist-tree.mat']));
im = imread(image);
K=200;
%numWords = size(vocab,2);
%docVec=zeros(1,numWords);
switch desc
   case 'sift'
        if(size(im,3)>=3)
            im = single(rgb2gray(im)) ;
        else
            im=single(im);
        end
end
[frames, descrs] = vl_sift(im) ;
size(descrs)
%b = vl_hikmeanshist(hist_tree,Path);
%d=b(end-10000+1:end);
%d=transpose(d);
%hists=cat(1,hists,d);
load('./sift-hist_tree.mat');
Path=vl_hikmeanspush(hist_tree,descrs);
a='Loading done result'
Hists=vl_hikmeanshist(hist_tree,Path);
Hists =Hists(end-10000+1:end);   %10000*1;
clear hist_tree;
a=find(Hists>0);            %618*1
load('./sift-inverted.mat');

ld='loading inverted' 
ani2=inverted(a(:));
clear inverted;
w=zeros(1,27243);
cnt=size(ani2,2)-1
load('./sift-idf.mat');
query_image=transpose(Hists);
numdocWords=size(a,1);
query_Vector=(query_image./numdocWords).*idf;
clear idf;
test=query_Vector(a(:));
plo='counting'
for i=1:cnt
%        i
        [a b c]=intersect(ani2{i}{2}(:),ani2{i+1}{2}(:));
        Sz=size(a,1);
        for j=1:Sz
                 if i==cnt
                         w(j)=w(j)+(ani2{i}{3}(b(j)))*test(i) + ani2{i+1}{3}(c(j))*test(i+1);
                else
                         w(j)=w(j)+ani2{i}{3}(b(j))*test(i);
                end
        end
end

[Ans Ans2]=sort(w,'descend');
Ans(1:10)
Ans2=Ans2*2+1;
Ans2(1:10)
for i=1:K
	ii=Ans2(i);
	if ii< 1501
		 count=6;  
 %               num=strcat('00',num2str(ii));
  %              img_name=strcat('../IMAGES/',num,'.jpg');
   %        elseif  ii>=10 & ii < 100
    %            num=strcat('0',num2str(ii));
     %           img_name=strcat('../IMAGES/',num,'.jpg');
           else
                num=num2str(ii);
                img_name=strcat('../IMAGES/',num2str(ii),'.jpg');
    		im=imread(img_name);
    		imwrite(im,['../results/',num2str(i),'.jpg'],'JPG');
           end
end
%save(fullfile('.','Ans.mat'),'Ans');
%save(fullfile('.','Ans2.mat'),'Ans2');

%hists{ii}=transpose(d);

%binsa = double(vl_kdtreequery(model,vocab,single(descrs))) ;
%docVec=hist(binsa,numWords);
%hists=cat(1,hists,docVec);
%--------------------------------------------- calculate doc vectors--------
%a='doc Vecotrs calculating'

%wordFrequency=sum(hists~=0);
%docVectors=zeros(size(hists));
%idf=(log(size(hists,1)*1.0./(wordFrequency+1)));
%for i=1:size(hists,1)
 %   numdocWords=sum(sum(hists(i,:)))+1;
  %  docVectors(i,:)=(hists(i,:)./numdocWords).*idf;
%end

%---------------------------------------------------------------------search and score
%a='Score calculating'
%size(docVectors)
%scores=zeros(size(hists,1)-1,1);
 %  for dn=1:size(hists,1)-1
%  	scores(dn,1)=sum(sum(hists(dn,:).*hists(end,:)))/(sum(sum((hists(dn,:).^2)))^0.5*sum(sum(hists(end,:).^2))^0.5);
%end

%[score,docNum]=sort(scores,'descend');
%score(1:10)
%docNum=docNum(1:10);
%%subplot(K/2+1,2,[1,2]),imshow(im);
%class=zeros(K);
%%K
 %   images{docNum(i)} % . It gives the name of the images similar to the
  %  %previous ones.
   % %subplot(K/2+1,2,i+2);
   % %imshow(im);
   % class(i)=imageClass(docNum(i));
%saveas(gca,strcat('dataset',image(1:end-4),'_result.jpg'),'jpg');

end
