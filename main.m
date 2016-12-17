% Main program to calculate crisp output of a sentence's sentiment
% with the help of a FLS

% Gather all the data
[word1, word2, word3, score1, score2, posscore, negscore] = readTrainData();

prompt = 'Press 1 for twitter, 2 for amazon, 3 for yelp and 4 for imdb data and press enter to confirm: ';
x = input(prompt);

% Give the user the choice which medium it wants to test
if x == 1
    [test_score, ~, test_sentences] = readTwitterTestData('Data/Test/Sentiment Analysis Dataset SMALL.csv',2, 1001);
elseif x == 2
    [test_sentences, test_score] = readTestData('Data/Test/amazon_cells_labelled.csv',2, 1001);
elseif x == 3
    [test_sentences, test_score] = readTestData('Data/Test/yelp_labelled.csv',2, 1001);
elseif x == 4
    [test_sentences, test_score] = readTestData('Data/Test/imdb_labelled.csv',2, 1001);
else
    error('Invalid data, program will abort');
end

% Read in the FLS
fls = readfis('FuzzySentiment.fis');
outcome_data = [];

% Set up the waitbar
h = waitbar(0,'1','Name','Classifying sentences...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

% Set numbers for the waitbar
full_length = size(test_sentences,1);
full_counter = 0;

for sentence = test_sentences'
    % Check for Cancel button press
    if getappdata(h,'canceling')
        break
    end
    
    % Break every sentence into seperate words and remove punctuation etc
    [sentence_words] = sentenceToWords(sentence{1});

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
        sentence_score_LABMT = 5;
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
    output = evalfis(input_fls, fls);
    full_counter = full_counter + 1;
    
    % if output is positive, set to 1 for comparisson with testdata 
    if output > 0
        outcome_data = [outcome_data; [1, output]];
    % else set to 0
    else
        outcome_data = [outcome_data; [0, output]];
    end
    % Report current estimate in the waitbar's message field
    percentage_complete = (full_counter / full_length) * 100;
    waitbar(full_counter / full_length,h,sprintf('%.2f', percentage_complete))
end

delete(h)       % DELETE the waitbar; don't try to CLOSE it.
result = outcome_data(:,1) == test_score;
accuaracy = (sum(result) / size(result,1)) * 100
