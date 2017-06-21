//
//  Session.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import Foundation

class Session {

    var timeDuration: Int!
    var playlistURI: String!
    var vibeType: String!
    
    init(length: Int, vibe: String) {
        timeDuration = length
        vibeType = vibe
        setMusic(vibe: vibeType)
    }
    
    func setMusic(vibe: String) {
        let music = MusicPicker()
        music.pickPlaylist(givenVibe: vibe)
        playlistURI = music.getPlaylistURI()
    }
    
}
