function [ score moreInfo] = getScore( target, trace, generic, plot )
%GETSCORE Calculate the letter scoring.
% Possible methods: imaging, SSE, resampling then SSE.
% Imaging method
if nargin < 4
    plot = 0;
end
%%
[gaus1 im1 blur1] = pixToIm(target,generic);
[gaus2 im2 blur2] = pixToIm(trace,generic);


% Calculate the score as a fraction 
youSuck = sum(sum(gaus1)); % Worst possible score: writing nothing at all.
score = sum(sum(abs(gaus1-gaus2)));
score = score/youSuck;

% Cutoff the score if it's really high. Mess with it so it shows up as a
% percentage.
if score > 1; score = 1; end
score = 1-score;
score = score*100;


% If generic.trialInfo exists, calculate a bunch of statistics on the
% individual trials. Otherwise, don't bother. Can mostly be ignored.
if isfield(generic,'trialInfo');
    %% Get rid of the leeway I allowed (100 pixels around the box).
    letlen = length(generic.trialInfo.theWord);
    lettime = generic.trialInfo.trialTime;

    g1 = gaus1(110:end-109,110:end-109);
    g2 = gaus2(110:end-109,110:end-109);
    i1 = im1(110:end-109,110:end-109);
    i2 = im2(110:end-109,110:end-109);

    strt = 1;
    subscores = NaN(1,letlen);
    for letter = 1:letlen
        if letter == letlen
            fin = size(g2,2);
        else
            fin = strt+round(size(g2,2)/letlen);
        end
        inbit1 = g1(:,strt:fin);
        inbit2 = g2(:,strt:fin);
        inim1 = i1(:,strt:fin);
        inim2 = i2(:,strt:fin);
        %% Calculate stuff
        youSuck = sum(sum(inbit1));
        subscore = sum(sum(abs(inbit1-inbit2)));
        subscore = subscore/youSuck;
        
        if letter == letlen
            if sum(sum(inbit2)) == 0
                unfinished = 1;
            else
                unfinished = 0;
            end
        end
        if ~isfield(generic,'real'); % it's not real! 
            if subscore > 1; subscore = 1; end
            subscore = 1-subscore;
            subscore = subscore*100;
        end
        subscores(letter) = subscore;
        if isfield(plot,'spec');
            subplot(2,2,1);
            imagesc(inbit1);
            subplot(2,2,2);
            imshow(inim1);
            subplot(2,2,3);
            imagesc(inbit2);
            subplot(2,2,4);
            imshow(inim2);
            suptitle([int2str(letter) '/' int2str(letlen) ' s: ' num2str(subscore,3)]);
            waitforbuttonpress;
        end
        strt = fin;
    end
    
    
    
% % %     strt = 1;
% % %     subscores = NaN(1,letlen);
% % %     for letter = 1:letlen
% % %         if generic.trialInfo.type
% % %             xlen = 88; % All shapes are the same size
% % %         else
% % %             let = generic.trialInfo.theWord(letter);
% % %             let = let - 'a' +1;
% % %             xlen = generic.letSize.lets(let).x;
% % %             fprintf('%i: %s - %s \n',xlen, generic.trialInfo.theWord(letter), generic.letSize.lets(let).let);
% % %         end
% % %         if letter == 1; 
% % %             fin = strt+xlen+10;
% % %             'first'
% % %         elseif letter == letlen
% % %             fin = size(g2,2);
% % %             'last'
% % %         else
% % %             fin = strt+xlen;
% % %         end
% % %         inbit1 = g1(:,strt:fin);
% % %         inbit2 = g2(:,strt:fin);
% % %         inim1 = i1(:,strt:fin);
% % %         inim2 = i2(:,strt:fin);
% % %         %%% Calculate shit
% % %         youSuck = sum(sum(inbit1));
% % %         subscore = sum(sum(abs(inbit1-inbit2)));
% % %         subscore = subscore/youSuck;
% % %         subscores(letter) = subscore;
% % %         
% % %         
% % % % % %         
% % % % % %         subplot(2,2,1);
% % % % % %         imagesc(inbit1);
% % % % % %         subplot(2,2,2);
% % % % % %         imshow(inim1);
% % % % % %         subplot(2,2,3);
% % % % % %         imagesc(inbit2);
% % % % % %         subplot(2,2,4);
% % % % % %         imshow(inim2);
% % % % % %         suptitle([int2str(letter) '/' int2str(letlen) ' s: ' num2str(subscore,3)]);
% % % % % %         waitforbuttonpress;
% % %         strt = fin;
% % %     end
    bad = mean(subscores(1:end-1));
% % %     bad = bad + std(subscores(1:end-1))*5;
% % %     if subscores(end) > bad && lettime/letlen >= 2; % NOTE! This flips with positive scoring!
% % %         moreInfo.finished = 0;
% % %     else
% % %         moreInfo.finished = 1;
% % %     end
    moreInfo.unfinished = unfinished;
    moreInfo.finished = ~logical(unfinished);

    moreInfo.subscores= subscores;
    
end

%%
% Plotting imaging stuff

if isfield(plot,'gen');
%     f = figure;
    subplot(2,2,1);
    imagesc(im1);
%     subplot(3,2,3);
%     imagesc(blur1);
    subplot(2,2,3);
    imagesc(gaus1);

    subplot(2,2,2);
    imagesc(im2);
%     subplot(3,2,4);
%     imagesc(blur2);
    subplot(2,2,4);
    imagesc(gaus2);
   if isfield(generic,'trialInfo');
        suptitle([int2str(moreInfo.finished) '-' num2str(moreInfo.subscores)]);
    end
%     print(f,'-dpng','-r600','BlurringDemo2.png');
%     subplot(2,1,1);
%     imshow(im1);
%     subplot(2,1,2);
%     imshow(im2);
   save('usefulPlottingStuff');

end

if isfield(plot,'paperPlot');
%     f = figure;
    subplot(2,2,1);
    imagesc(im1);
%     subplot(3,2,3);
%     imagesc(blur1);
    subplot(2,2,3);
    imagesc(gaus1);

    subplot(2,2,2);
    imagesc(im2);
%     subplot(3,2,4);
%     imagesc(blur2);
    subplot(2,2,4);
    imagesc(gaus2);
   if isfield(generic,'trialInfo');
        suptitle([int2str(moreInfo.finished) '-' num2str(moreInfo.subscores)]);
   end
    
%     print(f,'-dpng','-r600','BlurringDemo2.png');
%     subplot(2,1,1);
%     imshow(im1);
%     subplot(2,1,2);
%     imshow(im2);
end

end

