//
//  MovieDisplay.swift
//  Movie Library
//
//  Created by Zachary Whitten on 6/13/18.
//  Copyright © 2018 16^2. All rights reserved.
//

import Cocoa

class MovieDisplay: NSObject, NSTableViewDataSource, NSTableViewDelegate{

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var sidebarView: SidebarOutlineView!
    @IBOutlet weak var tableMenu: NSMenu!
    lazy var appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    var movieData: [String : Movie] = [:]
    var currentData: [Movie] = []
    var showOrder = false
    
    //Called by AppDelegate after application has finished launching. Think of this function as an initalization function
    func viewDidLoad(){
        //Set a unique autosave name so the configuration of the colums persist over app launches
        tableView.autosaveName = NSTableView.AutosaveName(rawValue: "MovieDisplayTableView")
        tableView.autosaveTableColumns = true
        //Registers the pasteboard types that the view will accept as the destination of an image-dragging session.
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "movie.data")])
        //Set the apperiance of the order column
        tableView.tableColumns[0].sortDescriptorPrototype = nil
        tableView.tableColumns[0].width = 20
        //Iterate over every column in the table view and if they are visable, make the coresponding NSMenuItem selected
        for column in tableView.tableColumns{
            let menuItem = tableMenu.item(withTitle: column.title)
            if menuItem != nil{
                if column.isHidden{
                    menuItem?.state = .off
                }
                else{
                    menuItem?.state = .on
                }
            }
        }

    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return currentData.count;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //Get the column identifer and create an empty cellView variable
        let identifier = tableColumn?.identifier.rawValue
        
        var cellView: NSTableCellView?

        if identifier == "order" {
            if showOrder{
                cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OrderCell"), owner: nil) as? NSTableCellView)!
                cellView!.textField?.stringValue = String(row+1)
            }
        }
        else if identifier == "title" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TitleCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].title ?? ""
        }
        else if identifier == "aspectRatio" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AspectRatioCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].aspectRatio ?? ""
        }
        else if identifier == "bitRate" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BitRateCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].bitrate ?? ""
        }
        else if identifier == "comments" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CommentsCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].comments ?? ""
        }
        else if identifier == "director" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DirectorCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].director ?? ""
        }
        else if identifier == "frameRate" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FrameRateCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].frameRate ?? ""
        }
        else if identifier == "genre" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenreCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].genre ?? ""
        }
        else if identifier == "height" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeightCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].height ?? ""
        }
        else if identifier == "playCount" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PlayCountCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = String(currentData[row].playCount)
        }
        else if identifier == "runTime" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RunTimeCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].runtime ?? ""
        }
        else if identifier == "size" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SizeCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].fileSize ?? ""
        }
        else if identifier == "videoMedia" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "VideoMediaCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].videoFormat ?? ""
        }
        else if identifier == "width" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "WidthCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = currentData[row].width ?? ""
        }
        else if identifier == "year" {
            cellView = (tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "YearCell"), owner: nil) as? NSTableCellView)!
            cellView!.textField?.stringValue = (currentData[row].year != nil ?  String(currentData[row].year!) : "")
        }
        
    
        // return the populated NSTableCellView
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        //Convert the data array into an NSMutableArray, sort that using the given SortDescriptor, and then convert it back to an array. Then reload the data. We do this because array can not be sorted by SortDescriptor as of Swift 4 but NSMutableArray can.
        //For Swift 4, https://stackoverflow.com/a/44790231 talks about class requirments to comply with objective-c sortDescriptors
        let dataMutableArray = NSMutableArray(array: currentData)
        dataMutableArray.sort(using: tableView.sortDescriptors)
        currentData = dataMutableArray as AnyObject as! [Movie]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
        if(columnIndex == 0 || newColumnIndex == 0){
            return false
        }
        else{
            return true
        }
    }
    
    @IBAction func TableViewClicked(_ sender: Any) {
        if tableView.selectedRowIndexes.isEmpty {
            //TODO disable edit and delete menu items
        }
        else{
            //TODO enable edit and delete menu items 
        }
    }
    
    @IBAction func TableViewMenuItem(_ sender: Any){
        //The sender has to be a MenuItem because only MenuItems are bound to this action. So we cast because that's what we're expecting
        let menuItem = (sender as! NSMenuItem)
        //Flip the state of the selected menu item
        menuItem.state == .off ? (menuItem.state = .on) : (menuItem.state = .off)
        //Identify the tableColumn assoicated with the selected menu item
        var tableColumn: NSTableColumn? = nil
        if menuItem.title == "Aspect Ratio" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "aspectRatio")) }
        if menuItem.title == "Bit Rate" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "bitRate")) }
        if menuItem.title == "Comments" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "comments")) }
        if menuItem.title == "Director" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "director")) }
        if menuItem.title == "Frame Rate" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "frameRate")) }
        if menuItem.title == "Genre" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "genre")) }
        if menuItem.title == "Height" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "height")) }
        if menuItem.title == "Play Count" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "playCount")) }
        if menuItem.title == "Run Time" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "runTime")) }
        if menuItem.title == "Size" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "size")) }
        if menuItem.title == "Title" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "title")) }
        if menuItem.title == "Video Media" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "videoMedia")) }
        if menuItem.title == "Width" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "width")) }
        if menuItem.title == "Year" { tableColumn = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "year")) }
        //If the specific tableColumn is visible, we make it hidden and shrink it's size to 0. If it's hidden, we make it visible and give it a width and a minimum width
        if(menuItem.state == .off){
            tableColumn?.isHidden = true
            tableColumn?.width = 0
            tableColumn?.minWidth = 0
        }
        else{
            tableColumn?.isHidden = false
            tableColumn?.width = 50
            tableColumn?.minWidth = 10
        }
        

    }
    
    //Drag and drop methods
    //Returns an NSPasteboardItem with the selected data to be dragged and dropped somewhere else
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        //Get the rows selected in this tableview and convert them to raw data
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        let item = NSPasteboardItem()
        //Add row data to NSPasteboardItem with a unique type identifer, then add the pastebard item to the given NSPasteboard
        item.setData(data, forType: NSPasteboard.PasteboardType(rawValue: "movie.data"))
        pboard.writeObjects([item])
        //Return true because this method is always sucessful (or its a crash)
        return true
    }
    
    //Determines if the currently dragged rows can be dropped in a specific location. Returns a NSDragOperation to indicate if items can be dragged to the specific location
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        //If the source of our dragged items is not our tableview, then return an empty array (which prevents the drop option from being displayed)
        guard let source = info.draggingSource() as? NSTableView,
            source === tableView
            else { return [] }
    
        //If the selected sidebar row is not a playlist, do not allow the items to be dropped on the tableview
        if sidebarView.selectedRow <= sidebarView.libItems.count {
            return []
        }
        
        //If the selected column is not the order column, do not allow items to be dropped on the table view
        if tableView.sortDescriptors[0].key != "uniqueID"{
            return []
        }
        
        //If the dragged items are attemting to be dropped above or below other items in the tableview, then we return an NSDragOperation, which displays to the use the option to drop the dragged items. If the dragged items are attemping to be dropped on an existing item, we return an empty array and the drop option is not displayed
        if dropOperation == .above {
            return .move
        }
        return []
    }
    
    //Is called after a drop takes placed. Used to update all necessary data structures
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        let pb = info.draggingPasteboard()
        if let itemData = pb.pasteboardItems?.first?.data(forType: NSPasteboard.PasteboardType(rawValue: "movie.data")), let indexes = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? IndexSet{
            
            let consecutive = indexes.contains(integersIn: indexes.first!...indexes.last!)
            if !(consecutive && indexes.contains(row-1)){
                var tempPlaylist: [String] = []
                var tempCurrentData: [Movie] = []
                
                let selectedPlaylist = sidebarView.getSelectedItem()
                let dummyMovie = Movie.init(aTitle: "", aFilepath: URL.init(fileURLWithPath: "/"))
                
                for index in indexes.reversed(){
                    tempPlaylist.append(selectedPlaylist.contents[index])
                    tempCurrentData.append(currentData[index])
                    currentData[index] = dummyMovie
                }

                for index in (0...tempPlaylist.count-1){
                    if row < currentData.count{
                        selectedPlaylist.contents.insert(tempPlaylist[index], at: row)
                        currentData.insert(tempCurrentData[index], at: row)
                    }
                    else{
                        selectedPlaylist.contents.append(tempPlaylist[index])
                        currentData.append(tempCurrentData[index])
                    }
                }
                
                for (index,movie) in currentData.enumerated().reversed(){
                    if movie === dummyMovie{
                        selectedPlaylist.contents.remove(at: index)
                        currentData.remove(at: index)
                    }
                }
                
                tableView.reloadData()
                NSKeyedArchiver.archiveRootObject(sidebarView.playlistItems, toFile: appDelegate.storedPlaylistsFilepath)
                return true
            }
            return false
        }
        return false
    }
    
}
