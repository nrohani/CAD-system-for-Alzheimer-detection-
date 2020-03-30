%% Project Title: Paddy Leaf Disease Detection

clc
close all 
clear all

     %% SVM Classifier
        % Load All The Features
        %load('Training_Data.mat')

        % Put the test features into variable 'test'
        test = feat_disease;
        result = multisvm(Train_Feat,Train_Label,test);
        %disp(result);

        
        %% Visualize Results
        if result == 1
            helpdlg(' Disease Detect ');
            disp(' Disease Detect ');
        else
            helpdlg(' Disease not Detect ');
            disp('Disease not Detect');
        end
    
    if (choice==3)
        close all;
        return;
    end
