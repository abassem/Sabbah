//
//  SearchableTableView.swift
//
//  Created by Bazyli Zygan on 01.01.2016.
//  Copyright © 2016 Nova Project. All rights reserved.
//

import UIKit

open class SearchableTableView: UITableView, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    // MARK: - API variables and methods
    
    @IBOutlet open var searchView: UIView?
    @IBOutlet override weak open var delegate: UITableViewDelegate? {
        get {
            return tableViewDelegate
        }
        
        set {
            tableViewDelegate = newValue
        }
    }
    
    open var translucentNavigationBar: Bool = true
    
    open var searchQuery: String? {
        get {
            if searchVisible {
                return searchController.searchBar.text
            } else {
                return nil
            }
        }
    }
    
    open func cancelSearch() {
        if searchView != nil && searchView == searchController.searchBar {
            searchController.isActive = false
        }
    }
    
    // MARK: - Implementation - DO NOT TOUCH!
    fileprivate var searchVisible = false
    fileprivate var searchController: UISearchController!
    fileprivate var offsetShift: CGFloat {
        get {
            return (translucentNavigationBar) ? 64.0 : 0
        }
    }
    
    fileprivate var tableViewDelegate: UITableViewDelegate?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { () -> Void in
            self.prepareSearchViews()
        }
    }
    
    // MARK: - ScrollView handling
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchView == nil || searchController.searchBar.isFirstResponder {
            return
        }
        
        if searchVisible {
                return
        }
        
        if scrollView.contentOffset.y < 0 {
            searchView!.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
        } else {
            searchView!.transform = CGAffineTransform.identity
        }
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if searchView == nil {
            return
        }
        
        if !searchVisible && scrollView.contentOffset.y+offsetShift < -searchView!.bounds.height {
            searchVisible = true
            let offset = scrollView.contentOffset.y + self.searchView!.bounds.height
            DispatchQueue.main.async(execute: { () -> Void in
                self.self.searchView!.removeFromSuperview()
                self.searchView!.frame = CGRect(x: 0, y: 0, width: self.searchView!.frame.width, height: self.searchView!.frame.height)
                self.tableHeaderView = self.searchView!
                self.searchView!.setNeedsDisplay()
                scrollView.contentOffset.y = offset
            })
        } else if searchVisible && scrollView.contentOffset.y+offsetShift >= searchView!.bounds.height {
            searchVisible = false
            let offset = scrollView.contentOffset.y - self.searchView!.bounds.height
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableHeaderView = nil
                if self.searchView == self.searchController.searchBar {
                    self.createSearchController()
                }
                self.searchView!.transform = CGAffineTransform.identity
                self.searchView!.frame = CGRect(x: 0, y: self.frame.origin.y-self.searchView!.frame.height, width: self.searchView!.frame.width, height: self.searchView!.frame.height)
                scrollView.contentOffset.y = offset
                self.superview?.addSubview(self.searchView!)
                self.searchView!.sizeToFit()
                self.searchView!.setNeedsDisplay()
                self.setNeedsDisplay()
                self.reloadData()
            })
            
        }
    }
    
    // MARK: - Transformation of UITableViewDelegates
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }

    open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if #available(iOS 9.0, *) {
            return tableViewDelegate?.tableView?(tableView, canFocusRowAt: indexPath) ?? true
        } else {
            return true
        }
    }
    
    open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return tableViewDelegate?.tableView?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender) ?? false
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableViewDelegate?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    @available(iOS 9.0, *)
    open func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        tableViewDelegate?.tableView?(tableView, didUpdateFocusIn: context, with: coordinator)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return tableViewDelegate?.tableView?(tableView, editActionsForRowAt: indexPath)
    }

    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return tableViewDelegate?.tableView?(tableView, editingStyleForRowAt: indexPath) ?? .none
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, estimatedHeightForFooterInSection: section) ?? 0
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, estimatedHeightForHeaderInSection: section) ?? 0
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, estimatedHeightForRowAt: indexPath) ?? 0
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, heightForFooterInSection: section) ?? 0
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, heightForHeaderInSection: section) ?? 0
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewDelegate?.tableView?(tableView, heightForRowAt: indexPath) ?? self.rowHeight
    }
    
    open func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return tableViewDelegate?.tableView?(tableView, indentationLevelForRowAt: indexPath) ?? 0
    }
    
    open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        tableViewDelegate?.tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }
    
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return tableViewDelegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) ?? true
    }
    
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return tableViewDelegate?.tableView?(tableView, shouldIndentWhileEditingRowAt: indexPath) ?? false
    }
    
    open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return tableViewDelegate?.tableView?(tableView, shouldShowMenuForRowAt: indexPath) ?? false
    }
    
    @available(iOS 9.0, *)
    open func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return tableViewDelegate?.tableView?(tableView, shouldUpdateFocusIn: context) ?? false
    }
    
    open func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return tableViewDelegate?.tableView?(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }
    
    open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return tableViewDelegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableViewDelegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewDelegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableViewDelegate?.tableView?(tableView, willDeselectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        tableViewDelegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableViewDelegate?.tableView?(tableView, willSelectRowAt: indexPath)
    }
    
    // MARK: - SearchBar delegates
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.resignFirstResponder()
        
    }
    
    open func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
    open func updateSearchResults(for searchController: UISearchController) {
        reloadData()
    }
    
    // MARK: - Private implementations
    fileprivate func prepareSearchViews() {

        createSearchController()
        
        searchView!.frame = CGRect(x: 0, y: frame.origin.y-searchView!.frame.height, width: searchView!.frame.width, height: searchView!.frame.height)
        super.delegate = self
        self.superview?.addSubview(searchView!)
        reloadData()
    }
    
    fileprivate func createSearchController() {
        if searchView == nil {
            searchController = UISearchController(searchResultsController: nil)
            // Testing adding an appropriate view
            searchController.searchBar.sizeToFit()
            self.searchController.searchResultsUpdater = self;
            
            self.searchController.dimsBackgroundDuringPresentation = false;
            
            // Search delegates
            self.searchController.delegate = self;
            self.searchController.searchBar.delegate = self;
            
            searchView = searchController.searchBar
        }
    }
}
