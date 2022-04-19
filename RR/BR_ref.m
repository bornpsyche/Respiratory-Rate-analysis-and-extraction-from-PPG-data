
for j=1:length(matData)
% define dimensions
numPoints = length(CO(j).y); % 2000 in your case
numSegments = 16; % number of segments
segLength = (numPoints-1)/numSegments;
% make a data array that has a column of data for each non-overlapping segment
Z = reshape(CO(j).y(1:144000,1),segLength,[])
%M = zeros(numSegments,1); % preallocate array to hold results
for k = 1:numSegments
    sig=Z(:,k);
    Fs=300;
    N = length(sig);
    t = [0:N-1]/Fs;
    dF = Fs/N;                    
    f = -Fs/2:dF:Fs/2-dF;
    sig=sig-mean(sig)
    X =fftshift(fft(sig));           

    [maxpeak, maxpeakindes] = max(abs(X)*2);
    results(j).a(2,k)=abs(f(maxpeakindes));
end
end