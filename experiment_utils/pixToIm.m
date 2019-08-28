function [ gausIm im blur ] = pixToIm( pixLet, generic, parms )
%PIXTOIM Convert the pixels into a blurry image
    %
try

    % Default values, used for the score the participant sees. You can
    % change this later in the analysis script if you want to.
if nargin < 3
    sz = 50;
    reach = 12;%10.5;%8; %10.5;
else 
    sz=parms.sz;
    reach=parms.reach;
end

% This is really ugly. Not sure why it's here. I guess because it's easier
% to modify things using the generic struct that's passed between functions
% than the parms struct. 
if isfield(generic,'reach');
    reach = generic.reach;
end
    
    
im = zeros(generic.theRect([4 3])); % The box. REMEMBER: x/y are swapped. Duh.

pixLet(pixLet==0) = 1; % Get rid of any 0's as the screw the system. Pretty unlikely to happen though.

% The data from the trackpad is recorded as a whole bunch of (x,y)
% coordinates. Here, we extrapolate the lines between each segment. We also
% detect line breaks, in case they lifted up the pen. 
if any(any(isnan(pixLet)))
    for pix = 2:size(pixLet,1)
        y1 = pixLet(pix-1,2); x1 = pixLet(pix-1,1);
        y2 = pixLet(pix,2); x2 = pixLet(pix,1);
        if ~isnan(y1) && ~ isnan(y2)
            xyd = round(pdist([x1 y1; x2 y2])*2);
            xs = round(linspace(x1,x2,xyd));
            ys = round(linspace(y1,y2,xyd));
            for linepix = 1:length(xs)
                im(ys(linepix),xs(linepix)) = 1;
            end
        end
    end
else 
    for pix = 1:size(pixLet,1)
        im(pixLet(pix,2),pixLet(pix,1)) = 1;
    end
end
% Now zoom in on the box
leeway = 100; % An amount of error around the box. Ignore massive jumps outside.
inx = generic.theBox.inX; inx = inx(1)-leeway:inx(end)+leeway;
iny = generic.theBox.inY; iny = iny(1)-leeway:iny(end)+leeway;
im = im(iny,inx,:);
% fprintf('lines: %1.2f', toc);
% Our blurring window
blur = fspecial('gaussian',[sz sz],reach);

% % % Apply the blurring window
% % % Regular way 
% % gausIm = imfilter(im(:,:,1),blur,'symmetric','conv');
% % % Faster way 
% % gausIm = imgaussian(im(:,:,1),reach,sz);
% % % It's like lightning!
gausIm = conv2(im(:,:,1),blur,'same');

%http://www.google.co.uk/url?sa=t&rct=j&q=matlab%20imfilter%20slow&source=web&cd=4&ved=0CD4QFjAD&url=http%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fanswers%2F13125-how-do-i-use-imfilter-to-high-pass-filter-an-image&ei=O64yT8bZEYHdtAa70YWuBA&usg=AFQjCNHV_TrXOK5BvuQ_MhQY5ReOeo4B7Q
if nargout > 2
    blur = fspecial('gaussian',[sz sz],reach);
end



%% Speed testing

% % % save('speeddat');
% % 
% % tic;
% % for i = 1:10;
% %     gausIm1 = imfilter(im(:,:,1),blur);
% % end
% % toc
% % tic;
% % for i = 1:10;
% %     gausIm2 = imfilter(im(:,:,1),blur,'symmetric','conv');
% % end
% % toc
% % tic;
% % for i = 1:10;
% % %     [U,S,V] = svd(blur);
% % %     v = U(:,1) * sqrt(S(1,1));
% % %     h = V(:,1)' * sqrt(S(1,1));
% % blur = fspecial('gaussian',[sz sz],reach);
% %     gausIm3 = conv2(im(:,:,1),blur,'same');
% % %     gausIm3 = filter2(blur,im(:,:,1));
% %     
% % end
% % toc
% % %%
% % g12 = gausIm1-gausIm2;
% % sum(sum(abs(g12)))
% % max(g12)
% % 
% % sum(sum(gausIm1-gausIm3))
% % sum(sum(gausIm2-gausIm3))
% % %% This looks awesome! 
% % imagesc(gausIm2-gausIm3)

catch
    err = lasterror;
    save('pixToIm-error');
    error('Error in pixToIm');
end

end

