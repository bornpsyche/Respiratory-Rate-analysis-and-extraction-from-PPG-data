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
set(gcf,'color','w');
subplot(211)
plot(t,sig,'-b','LineSmoothing','On');
xlabel('Time(Seconds)','FontSize', 16);ylabel('Amplitude','FontSize', 16);title('Processed PPG Signal','FontSize', 16);
axis([0  30    ylim]);

t = linspace(0, numel(sig), numel(sig))/Fs;
Ts = mean(diff(t));                                         % Sampling Interval
Fs = 1/Ts;                                                  % Sampling Frequency
Fn = Fs/2;                                                  % Nyquist Frequency
L = numel(t);                                               % Signal Length
sig = sig - mean(sig);
FTsig = fft(sig)/L;                                    % Fourier Transform
Fv = linspace(0, 1, fix(L/2)+1)*Fn;                         % Frequency Vector
Iv = 1:numel(Fv); 
[maxpeak, maxpeakindes] = max(abs(FTsig)*2);
maxfeq=Fv(maxpeakindes)
figure(2)
subplot(211)
plot(Fv, abs(FTsig(Iv))*2)
xlabel('Frequency(Hz)');ylabel('Magnitude(dB)');title('FFT of PPG signal')
grid
axis([0  3    ylim])