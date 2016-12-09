% Split all words in a sentence and remove punctuation
function [ clean_words ] = sentenceToWords( sentence )
    words = strsplit(sentence);
    clean_words = [];
    
    for word = words
        updated_word = regexprep(word,'[^A-Za-z0-9''_]','');
        clean_words = [clean_words, updated_word];
    end
    
end

