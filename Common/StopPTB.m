sca;
Priority(0);
% FlushEvents;
% ListenChar(0);
ShowCursor;
diary off

KL.GetQueue;
KL.Stop;
KL.ScaleTime;
KL.ComputeDurations;
KL.BuildGraph;
KLstruct = KL.ExportToStructure; % to be safe
