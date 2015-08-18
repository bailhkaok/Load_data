function [ lastprt ] = ScouseTom_data_checkfirstinj( V,Fs,Prot,curInjSwitch,curFreqSwitch,idx_f,datawindow,SingleFreqMode )
%SCOSUETOM_DATA_CHECKFIRSTINJ Checks the first injection in the dataset to
%see if it is the correct protocol line, adjusts the processing if not.
%This is to account for
%   Detailed explanation goes here

%% check inputs are ok

%if the data is fucked or has big artefact then this can mess up as the RMS
%is borked



%% checking for the double prt pulse goes here



%% find which bit of the dataset to use
if SingleFreqMode
    
    %take either the first injection or the first second
    
    tmp=curInjSwitch(idx_f+1)-curInjSwitch(idx_f);
    if tmp > Fs
        tmp=Fs;
    end
    
    tmpidx=curInjSwitch(idx_f)-datawindow(1):curInjSwitch(idx_f)-datawindow(1)+tmp;
    
    
else
    
    %take either the first injection or the first second
    
    tmp=curFreqSwitch(3)-curFreqSwitch(2);
    if tmp > Fs
        tmp=Fs;
    end
    
    tmpidx=curFreqSwitch(2)-datawindow(1):curFreqSwitch-datawindow(1)+tmp;
    
end

%% estimate the injection pair

%estimate the injection pairs from the two largest RMS values
[InjPairs, estimatebadness]=ScouseTom_data_EstInjPair(V(tmpidx,:));

%get the injection pair from the protocol
ProtPairs=Prot(1,:)';


%if the estimation is OK then calculate automatically

if estimatebadness == 0
    
    %if the injection channels match then crack on
    if all(sort(InjPairs)==sort(ProtPairs)) ==1
        %disp('Data starts with first protocol line');
        lastprt=0; %this is already set above but being didactic
    else
        disp('----------------------');
        warning('Data DOES NOT start with first protocol line');
        
        %find matching protocl line
        start_poss=find(all([InjPairs(1)==Prot(:,1) InjPairs(2)==Prot(:,2)],2));
        disp(['Starting injection pair was found to be : ', num2str(start_poss)])
        disp('Data processing carrying on now...');
        
        lastprt=start_poss-1;
    end
    
else
    disp('----------------------');
    %if it is still ambiguous - ask the user what to do
    msgbox('Starting injection pair is ambiguous! Please check the graph and enter manually','Uh Oh!');
    
    %plot the voltages for this swithc
    figure;
    plot(V(tmpidx,:));
    title('starting injection data - ambiguous injection');
    
    %ask them to input which protocol line this
    start_poss=input('Please enter the protocol line or leave empty to use best guess:');
    
    %is its empty just use best guess
    if isempty(start_poss)
        disp('FINE! I will just use the possibly wrong guess then shall I?');
        start_poss=find(all([InjPairs(1)==Prot(:,1) InjPairs(2)==Prot(:,2)],2));
        
        disp(['Starting injection pair was found to be : ', num2str(start_poss)'])
        disp('Data processing carrying on now...');
    end
    lastprt=start_poss-1;
    disp('----------------------');
end

end

