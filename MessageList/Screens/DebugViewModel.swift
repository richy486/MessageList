//
//  DebugViewModel.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import ReSwift
import RxSwift

typealias CloseClosure = () -> Void

class DebugViewModel {
    
    // MARK: - Observable vars

    // Using a lazy var observer for the content that maps the static values combined with the Redux state settings into
    // presenters that can be used by the View Controller and it's table view.
    private let sectionValues: Observable<[SectionValue]> = Observable.just(DebugViewModel.sectionStaticValues)
    lazy var content: Observable<[DebugMenuSectionPresenter]> = {
        
        settingsState.asObservable().withLatestFrom(sectionValues) { (settingsState: $0, sectionValues: $1) }
            .map { arg -> [DebugMenuSectionPresenter] in
                let a = arg.sectionValues.map({ section -> DebugMenuSectionPresenter in
                    let itemPresenters: [DebugMenuItemPresenter] = section.items.map { item -> DebugMenuItemPresenter in
                        
                        var optionState: DebugOptionState = .none
                        if let keyPath = item.keyPath {
                            optionState = arg.settingsState[keyPath: keyPath] ? .enabled : .disabled
                        }
                        
                        return DebugMenuItemPresenter(title: item.title, iconCharacter: item.iconCharacter, optionState: optionState)
                    }
                    let sectionPresenter = DebugMenuSectionPresenter(title: section.title, items: itemPresenters)
                    return sectionPresenter
                })
                
                return a
            }
    }()
    
    var didRequestClose: CloseClosure? = nil
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let settingsState = Variable<SettingsState>(SettingsState(useShiftedDate: true))
    
    private typealias ItemValue = (title: String, iconCharacter: Character, action: Action, keyPath: WritableKeyPath<SettingsState, Bool>?)
    private typealias SectionValue = (title: String, items: [ItemValue])
    private static let sectionStaticValues: [SectionValue] = [
        (
            Localizations.Debug.Debug,
            [
                (title: Localizations.Debug.ClearImageCache, iconCharacter: "🖼", action: SettingsAction.clearImageCache, keyPath: nil),
                (title: Localizations.Debug.UseShiftedDates, iconCharacter: "📆", action: SettingsAction.changeUseShiftedDate, keyPath: \SettingsState.useShiftedDate)
            ]
        )
    ]
    
    required init() {
        store.subscribe(self)
    }
    
    func closeTapped() {
        if let didRequestClose = didRequestClose {
            didRequestClose()
        }
    }
    
    func didTapItem(at indexPath: IndexPath) {
        let action = DebugViewModel.sectionStaticValues[indexPath.section].items[indexPath.row].action
        store.dispatch(action)
    }
}

extension DebugViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = State
    
    func newState(state: StoreSubscriberStateType) {
        settingsState.value = state.settingsState
    }
}
