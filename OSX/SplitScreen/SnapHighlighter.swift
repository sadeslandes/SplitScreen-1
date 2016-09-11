//
//  SnapHighlighter.swift
//  SplitScreen
//
//  Created by Evan Thompson on 7/1/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class SnapHighlighter {
    
    private var timer_delay_create: NSTimer // Timer used to delay creation of the highlighting window
    private var timer_updater: NSTimer // Timer used for window updating (.4 seconds)
    private var highlight_window: NSWindow? // The actual highlighting window
    private var window_dims: (Int, Int, Int, Int) // The dimensions for the hightlighting window
	
	
	/**
		Inits `SnapHighlighter` with timer vairiables and actual window
	*/
    init(){
        timer_delay_create = NSTimer()
        timer_updater = NSTimer()
        highlight_window = NSWindow()
        window_dims = (0,0,0,0)
    }
	
	/**
		Creates and draws the actual window also setting it up to update
	*/
    func draw_create (){
        let window_rect = NSRect(x: window_dims.0, y: Int((NSScreen.mainScreen()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        
        // The setup for the highlighting window
        highlight_window = NSWindow(contentRect: window_rect, styleMask: 0, backing: NSBackingStoreType.Nonretained, defer: true)
        highlight_window?.opaque = true
        highlight_window?.backgroundColor = NSColor.blueColor()
        highlight_window?.setIsVisible(true)
        highlight_window?.alphaValue = 0.3
        highlight_window?.orderFrontRegardless()
        
        //need to make the window the front most window?
        //want it to be an overlay as opposed to behind the dragged window
        //user needs to be able to see it
        
        // Start updating the window
        timer_updater = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(highlight_update), userInfo: nil, repeats: true)
        
    }
    
	/**
		Callback for the delay timer
	*/
    @objc func update_on_delay() {
        // Adds the dimensions info so that a window can be created
        snap_highlighter.update_window(layout.get_snap_dimensions(last_known_mouse_drag!.x, y: last_known_mouse_drag!.y))
        snap_highlighter.draw_create()
    }
    
	/**
		Sets up the timer to delay the creation of the window
	*/
    func delay_update(delay: Double){
        timer_delay_create = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(update_on_delay), userInfo: nil, repeats: false)
    }
    
	/**
		Stops timer for delayed creation
	*/
    func kill_delay_create(){
        timer_delay_create.invalidate()
    }
    
	/**
		Updates the window for highlighting
	*/
    @objc func highlight_update(){
        highlight_window?.update()
    }
    
	/**
		Destroys the window
	*/
    func draw_destroy (){
        timer_updater.invalidate()
        highlight_window?.opaque = false
        highlight_window?.setIsVisible(false)
    }
    
	/**
		Updates the window dimensions
	*/
    func update_window(new_dimensions: (Int, Int, Int, Int)){
        window_dims = new_dimensions
        let new_frame = NSRect(x: window_dims.0, y: Int((NSScreen.mainScreen()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        highlight_window?.setFrame(new_frame, display: true, animate: true)
    }
}
