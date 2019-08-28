% Playing with fixing the screen resolution bug.

trial = load('templates\words\aber.mat');

scrnRes = generic.theRect(3:4);

calcRes = [1920 1080];

%%
convT=trial;
if all (calcRes ~= scrnRes)
    offset = [scrnRes(1)/2 - calcRes(1)/2 scrnRes(2)/2 - calcRes(2)/2];
    convT.templateLet = round(bsxfun(@minus,convT.templateLet, offset(1)));
    convT.templateLet = round(bsxfun(@minus,convT.templateLet, offset(1)));

end

