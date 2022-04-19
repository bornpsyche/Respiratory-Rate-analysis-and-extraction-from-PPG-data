
clear Z n sig imf M s p;
Z=PPGsig(1).y;
n=1;
sig=Z(9000*n-8999:9000*n,1);
sig = sgolayfilt(sig,3,9);


%[imf]=emd(sig,'MAXMODES',10);
[imf]=eemd(sig,0.2,5,2000);
%[imf]=ceemd1(sig,0.2,5,10);
%[imf]=iceemdan(sig,0.2,5,2000,1);
%[imf]=ceemdan(sig,0.2,5,2000);

Fs=300;
N = length(sig);
t = [0:N-1]/Fs;

dF = Fs/N;                    
f = -Fs/2:dF:Fs/2-dF;  


figure(1);
subplot(311);
set(gcf,'color','w');
plot(t,sig,'-b');
xlabel('Time(Seconds)');ylabel('Amplitude');title('PPG Signal');
axis([0  30    ylim]);

c=0;
figure(2);
set(gcf,'color','w');
set(gca, 'Position', [-0.1,0.1,1.2,0.85])
set(gca, 'OuterPosition', [0,0,1,1])
for i=1:(size(imf,1)-1)
    subplot(size(imf,1),1,i);
    plot(t,imf(i,:));
    ylabel((sprintf('IMF %d', i)));set(gca,'XTick',[], 'YTick', []);
    hold on;
    X = fftshift(fft(imf(i,:)));
    [maxpeak, maxpeakindes] = max(abs(X)*2);
    if [(abs(f(maxpeakindes)))>=0.05 && (abs(f(maxpeakindes)))<=0.75]
        c=c+1;
        q=i;
        M(c,:)=imf(i,:)

    end
end
subplot(size(imf,1),1,size(imf,1));
plot(t,imf(size(imf,1),:));
ylabel('Res');xlabel('Time(Seconds)');set(gca, 'YTick', []);

figure(3);
set(gcf,'color','w');
for i=1:size(M,1)
    subplot(size(M,1),1,i);
    plot(t,M(i,:));
    ylabel((sprintf('IMF %d',q-size(M,1)+i)));set(gca, 'YTick', []);
    hold on
end
xlabel('Time(Seconds)');
[s,p]=pca(M);


figure(4);
set(gcf,'color','w');
subplot(211);
plot(t,s(:,1),'-b');
xlabel('Time(Seconds)');ylabel('Amplitude');title('First PC for the selected IMFs');
axis([0  30    ylim]);

X = fftshift(fft(s(:,1)/N));
         

figure(5);
set(gcf,'color','w');
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Frequency Spectrum of the first PC');
axis([0  3    ylim]);

Z=COsig(1).y;
n=1;
sig=Z(9000*n-8999:9000*n,1);
figure(6);
set(gcf,'color','w');
subplot(211);
plot(t,sig,'-b');
xlabel('Time(Seconds)');ylabel('Amplitude');title('Reference Respiration Signal');
axis([0  30    ylim]);
sig=sig-mean(sig)
X =fftshift(fft(sig));
figure(7);
set(gcf,'color','w');
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Magnitude Response of Refence sig');
axis([0  3    ylim])