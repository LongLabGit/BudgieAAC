function [warbleSyllableFlag, warbleInfo] = getWarble(syllables)

warbleSyllableIntervalMax = 1;
warbleElementsMin = 3;

syInterval = syllables(2:end, 1)-syllables(1:end-1,2);

if any(syInterval<=0)
    error('Syllables have to be ranked in order')
end

stream = syInterval<warbleSyllableIntervalMax;

[startEnd, duration] = calContinuousInterval(stream);

warbleSyllableFlag = false(size(syllables,1), 1);
warbleInfo = struct();

j = 1;
for i = 1:size(startEnd,1)
    if duration(i)+1 >= warbleElementsMin
        warbleInfo(j).syllabes = startEnd(i,1):startEnd(i,2)+1;
        warbleInfo(j).start = syllables(startEnd(i,1),1);
        warbleInfo(j).end = syllables(startEnd(i,2)+1,2);
        warbleInfo(j).duration = warbleInfo(j).end-warbleInfo(j).start;
        warbleSyllableFlag(warbleInfo(j).syllabes) = 1;
        j = j+1;
    end
end
