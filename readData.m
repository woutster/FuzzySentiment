% Read in all data from all the preprocessed datasets.
function [word1, word2, word3, score1, score2, posscore, negscore ] = readData()
    [word1, score1] = importSingleVariable('Data/AFINN-111-preprocessed.csv', 2, 2463);
    [word2, score2] = importSingleVariable('Data/labmt-preproc.csv', 2, 10223);
    [word3, posscore, negscore] = importDoubleVariable('Data/SentiNet-preprocessed.csv', 2, 116649);
    
end

