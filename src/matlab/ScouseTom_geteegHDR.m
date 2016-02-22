function [ HDR ] = ScouseTom_geteegHDR( varargin )
%SCOUSETOM_GETBDFHDR Summary of this function goes here
%   Detailed explanation goes here


%% Ask user for file if not given
%prompt user if no inputs
if isempty(varargin) == 1
    
    [filename, pathname] = uigetfile('*.eeg', 'Choose which ActiChamp file to load');
    if isequal(filename,0) || isequal(pathname,0)
        error('User pressed cancel')
    else
        disp(['User selected ', fullfile(pathname, filename)])
    end
    
    eegname =fullfile(pathname,filename);

else
    eegname = varargin{1};
    
end

%% Read HDR header

%Actichamp is much nicer so loading HDR is much less complicated

HDR=sopen(eegname);


end
