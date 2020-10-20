%% run ambisonics B-Format processing
clear all
% addpath to functions
addpath(['C:\Users\Darren Moore\The University of Nottingham\', ...
    'O365-MRCprogramme-MR-S002898-1 - 98_Darren_temp\software\', ...
    'Ambisonics\Functions_v2']);

B_Format_file = ['C:\Users\Darren Moore\The University of Nottingham\', ...
    'O365-MRCprogramme-MR-S002898-1 - 98_Darren_temp\ambisonicrecordings\', ...
    'bug_fly_by.wav'];
encodingConvention = 'ambix';


[SpeakerArray, B_Format_Channels_Struc, Decoder, Filters, speaker_feeds] = ... 
    convert_B_Format_to_speaker_feeds(B_Format_file, encodingConvention, ...
    true);

disp(SpeakerArray)
disp(B_Format_Channels_Struc)
disp(Decoder)
disp(Filters)


