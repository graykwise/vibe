//
//  MusicPicker.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import Foundation

class MusicPicker {
    var vibe: String!
    var playlistName: String!
    
    init() {
        vibe = ""
        playlistName = ""
    }
    
    func pickPlaylist(givenVibe: String) {
        switch givenVibe {
        case "Chill":
            //Set playlist for chill vibe
            //Chill Hits
            playlistName = "spotify:user:spotify:playlist:37i9dQZF1DX4WYpdgoIcn6"
            break
        case "Focus":
            //Set playlist for focus vibe
            //Deep Focus
            playlistName = "spotify:user:spotify:playlist:37i9dQZF1DWZeKCadgRdKQ"
            break
        case "Energize":
            //Set playlist for chill vibe
            //Energizing hits
            playlistName = "spotify:user:spotify:playlist:37i9dQZF1DWSWboXWl2xwB"
            break
        default:
            break
        }
    }
    
    func getPlaylistURI() -> String {
        return playlistName
    }
}
