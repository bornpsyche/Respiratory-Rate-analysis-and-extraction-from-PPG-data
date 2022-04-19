myFolder = 'C:\Users\A S H U\Desktop\Capnobase Data'; % Define your working folder
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);
for k = 1:length(matFiles)
  baseFileName = matFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  matData(k) = load(fullFileName);
end
PPGsig=arrayfun(@(k) matData(k).signal.pleth, 1:numel(matData));
COsig=arrayfun(@(k) matData(k).signal.co2, 1:numel(matData));
addpath('C:\Users\A S H U\Desktop\RR\Functions');
addpath('C:\Users\A S H U\Desktop\SSA');
load('C:\Users\A S H U\Desktop\RR\output.mat');