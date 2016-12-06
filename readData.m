function [word1, word2, word3, score1, score2, posscore, negscore ] = readData()
    % Read in all data
    [word1, score1] = importSingleVariable('Data/AFINN-111-preprocessed.csv', 2, 2463);
    [word2, score2] = importSingleVariable('Data/labmt-preproc.csv', 2, 10223);
    [word3, posscore, negscore] = importDoubleVariable('Data/SentiWordNet_3.0.0_20130122-preprocessed.csv', 2, 116649);
    
end

