function [ ] = ScouseTom_ProcessBatch( dirname )
%SCOUSETOM_PROCESSBATCH Summary of this function goes here
%   Detailed explanation goes here

%% Check or get directory

if exist('dirname','var') ==0
    %user chooses directory where all the .bdfs are
    dirname=uigetdir('','Pick the directory where the data is located');
    if isempty(dirname)
        error('User Pressed Cancel');
    end
end
%% find all the eeg files in the directory

bdffiles=dir([dirname filesep '*.bdf']);
eegfiles=dir([dirname filesep '*.eeg']);

% check if there are scans actually found
if isempty(bdffiles) && isempty(eegfiles)
    error('No eeg or bdf files found!');
end

nbdffiles=length(bdffiles);
neegfiles=length(eegfiles);

disp(['Found ' num2str(nbdffiles) ' .bdf files in directory']);
disp(['Found ' num2str(neegfiles) ' .eeg files in directory']);

%ignore small files <1Mb as these are empty

smallbdffile=cell2mat({bdffiles.bytes})/1e6;
smallbdffile = smallbdffile < 1;

if any(smallbdffile)
    fprintf(2,'WARNING! %d VERY SMALL (<1 Mb) bdf file(s) were detected! These will be ignored\n',num2str(nnz(smallbdffile)));
    bdffiles(smallbdffile)=[];
end

smalleegfile=cell2mat({bdffiles.bytes})/1e6;
smalleegfile = smalleegfile < 1;

if any(smalleegfile)
    fprintf(2,'WARNING! %d VERY SMALL (<1 Mb) eeg file(s) were detected! These will be ignored\n',num2str(nnz(smalleegfile)));
    bdffiles(smalleegfile)=[];
end

nbdffiles=length(bdffiles);
neegfiles=length(eegfiles);

%% process each bdf!
if (nbdffiles > 0)
    tic
    for iFile =1:nbdffiles
        disp(['Processing bdf file ' num2str(iFile) ' of ' num2str(nbdffiles) ': ' bdffiles(iFile).name]);
        ScouseTom_LoadBV(fullfile(dirname,bdffiles(iFile).name));
        disp('=========================================================');
    end
    el=toc;
    fprintf('All .BDF Processing finished in : %.2f seconds\r\n',el);  
end
%% process each eeg
if (neegfiles > 0)
    tic
    for iFile =1:neegfiles
        disp(['Processing eeg file ' num2str(iFile) ' of ' num2str(neegfiles) ': ' eegfiles(iFile).name]);
        ScouseTom_LoadBV(fullfile(dirname,eegfiles(iFile).name));
        disp('=========================================================');
    end
    el=toc;
    fprintf('All .EEG Processing finished in : %.2f seconds\n',el);  
end

%% 

fprintf('ALL DONE! AWW YISSSS\n');



end
