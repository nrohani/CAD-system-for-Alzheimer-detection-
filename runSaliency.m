clc;
clear;
MainPath = 'D:\My papers\ALZ\data1\Data\';

imageDir = '\DICOM\'; % replace with you image directory

imgList = dir([imageDir '*.png']);
MAT = [];
Label = readtable('label1.csv', 'HeaderLines',0);
Label = table2array(Label);
for zz = 1:50
    
    PT = [MainPath num2str(zz) imageDir];
    cd(PT);
    imgList = dir([PT '*.png']);
    
    for i = 1:1
        %% load a RGB image
        img = imread(imgList(i).name);
        [x, y, ~] = size(img);
        K = zeros(size(img,1),size(img,2),3);
        K(:,:,1) = img;
        K(:,:,2) = img;
        K(:,:,3) = img;
        img = K;
        
        %% transform it to LAB
        img = RGB2Lab(img);
        
        %% laod a prior or perform uniform initialization
        
        % if you have prior
        load('prior');
        % otherwise
        % p1 = 0.5*ones(128, 171); % uncomment for uniform initialization
        
        %% compute the saliency
        % function saliency = computeFinalSaliency(image, pScale, sScale, alpha, sigma0, sigma1, p1)
        FES = computeFinalSaliency(img, [8 8 8], [13 25 38], 30, 10, 1, p1);
        FES = imresize(FES, [x,y]);
        mink = min(FES(:));
        maxk = max(FES(:));
        FES = (FES - mink)./(maxk - mink);
     
        Cov = CovSal(img);
        Cov = imresize(Cov,[x,y]);
        
        FS = (FES + Cov)/2;
        Cov=Cov(:);
        MAT=[MAT;transpose(Cov)];
        Cov=[];
%         imwrite(FS, strcat('C:\Users\Nasim\Desktop\New folder (2)\code\',num2str(imgList(i).name)));
    end
    
end
