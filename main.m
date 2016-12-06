[word1, word2, word3, score1, score2, posscore, negscore] = readData();

%sentence = getSentence();
sentence = 'this is, a very good example.';

[sentence_words] = sentenceToWords(sentence);

sentence_score_1 = 0;
count1 = 0;
sentence_score_2 = 0;
count2 = 0;
sentence_score_3 = 0;
count3 = 0;

for word = sentence_words
   if ismember(word, word1)
       index = strmatch(word, word1, 'exact');
       word_score_1 = score1(index);
       sentence_score_1 = sentence_score_1 + word_score_1;
       count1 = count1 + 1;
   end
   if ismember(word, word2)
       index = strmatch(word, word2, 'exact');
       word_score_2 = score2(index);
       sentence_score_2 = sentence_score_2 + word_score_2;
       count2 = count2 + 1;
   end
   if ismember(word, word3)
       index = strmatch(word, word3, 'exact');
       word_pos = posscore(index)
       word_neg = negscore(index)
       sentence_score_3 = sentence_score_3 + word_pos - word_neg;
       count3 = count3 + 1;
   end   
end

sentence_score_1 = sentence_score_1 / count1
sentence_score_2 = sentence_score_2 / count2
sentence_score_3 = sentence_score_3 / count3