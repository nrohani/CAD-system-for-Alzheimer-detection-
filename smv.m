
k=5;

cvFolds = crossvalind('Kfold', groups, k);   %# get indices of 10-fold CV
cp = classperf(groups);                      %# init performance tracker
meas=MAT;
for i = 1:k                                  %# for each fold
    testIdx = (cvFolds == i);                %# get indices of test instances
    trainIdx = ~testIdx;                     %# get indices training instances

    %# train an SVM model over training instances
    svmModel = svmtrain(meas(trainIdx,:), groups(trainIdx), ...
                 'Autoscale',true, 'Showplot',false, 'Method','QP', ...
                 'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'RBF_Sigma',1);

    %# test using test instances
    pred = svmclassify(svmModel, meas(testIdx,:), 'Showplot',false);

    %# evaluate and update performance object
    cp = classperf(cp, pred, testIdx);
end

%# get accuracy
cp.CorrectRate

%# get confusion matrix
%# columns:actual, rows:predicted, last-row: unclassified instances
cp.CountingMatrix