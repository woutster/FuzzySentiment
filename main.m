% Main program to calculate crisp output of a sentence's sentiment
% with the help of a FLS

% Gather all the data
[word1, word2, word3, score1, score2, posscore, negscore] = readData();

% For now this is a test sentence, must be gathered as well
%sentence = getSentence();
sentence = 'this is, a good example.';

% Break every sentence into seperate words and remove punctuation etc
[sentence_words] = sentenceToWords(sentence);

% Set initial values
sentence_score_AFINN = 0;
count_AFINN = 0;
sentence_score_LABMT = 0;
count_LABMT = 0;
sentence_score_SENTINET_POS = 0;
count_SENTINET_POS = 0;
sentence_score_SENTINET_NEG = 0;
count_SENTINET_NEG = 0;


% For every word in the sentence, get the sentiment based on three
% different datasets
for word = sentence_words
   if ismember(word, word1)
       index = strmatch(word, word1, 'exact');
       word_score_1 = score1(index);
       sentence_score_AFINN = sentence_score_AFINN + word_score_1;
       count_AFINN = count_AFINN + 1;
   end
   if ismember(word, word2)
       index = strmatch(word, word2, 'exact');
       word_score_2 = score2(index);
       sentence_score_LABMT = sentence_score_LABMT + word_score_2;
       count_LABMT = count_LABMT + 1;
   end
   if ismember(word, word3)
       index = strmatch(word, word3, 'exact');
       word_pos = posscore(index);
       
       % At this moment some words occur multiple times in the SentiNet
       % dataset, here we get all the values for a single word an take the
       % average of those values
       if size(word_pos, 1) > 1
           word_pos = mean(word_pos);
       end
       word_neg = negscore(index);
       if size(word_neg, 1) > 1
           word_neg = mean(word_neg);
       end
       
       sentence_score_SENTINET_POS = sentence_score_SENTINET_POS + word_pos;
       count_SENTINET_POS = count_SENTINET_POS + 1;
       sentence_score_SENTINET_NEG = sentence_score_SENTINET_NEG - word_neg;
       count_SENTINET_NEG = count_SENTINET_NEG + 1;
   end  
end

% Get an average sentiment for the sentence based on the amount of
% sentimental words in the sentence
sentence_score_AFINN = sentence_score_AFINN / count_AFINN;
sentence_score_LABMT = sentence_score_LABMT / count_LABMT;
sentence_score_SENTINET_POS = sentence_score_SENTINET_POS / count_SENTINET_POS;
sentence_score_SENTINET_NEG = abs(sentence_score_SENTINET_NEG / count_SENTINET_NEG);

% If there were no sentimental words, set values to neutral
if isnan(sentence_score_AFINN)
    sentence_score_AFINN = 0;
end
if isnan(sentence_score_LABMT)
    sentence_score_LABMT = 0.5;
end
if isnan(sentence_score_SENTINET_POS)
    sentence_score_SENTINET_POS = 0.5;
end
if isnan(sentence_score_SENTINET_NEG)
    sentence_score_SENTINET_NEG = 0.5;
end

% Make the input for the FLS
input_fls = [
    sentence_score_AFINN,
    sentence_score_SENTINET_POS,
    sentence_score_SENTINET_NEG,
    sentence_score_LABMT];

% Put it in the FLS and generate crisp output
fls = readfis('FuzzySentiment.fis');
output = evalfis(input_fls, fls)
