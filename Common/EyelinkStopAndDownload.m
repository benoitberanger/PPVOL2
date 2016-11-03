if eyelink
    
    Eyelink.StopRecording( eyelinkFileName, saveFilePath )
    
    movefile([ saveFilePath filesep eyelinkFileName '.edf' ],[ saveFileName '.edf' ])
    
end
